// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_WaveHeight("WaveHeight", Range( 0 , 0.2)) = 0.06
		_TimeSpeed("TimeSpeed", Float) = 2
		_WaterColor("WaterColor", Color) = (0.2541118,0.7452364,0.7830189,0.7803922)
		_FoamColor("FoamColor", Color) = (0.6735849,0.9758211,1,0.7803922)
		_FrequencyX("FrequencyX", Float) = 8
		_FrequencyY("FrequencyY", Float) = 5
		_AmplitudeY("AmplitudeY", Float) = 0.02
		_AmplitudeX("AmplitudeX", Float) = 0.02
		_InteractorUV("_InteractorUV", Vector) = (0,0,0,0)
		_FoamRadius("FoamRadius", Float) = 0

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		GrabPass{ }

		Pass
		{
		CGPROGRAM
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _WaveHeight;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _FrequencyX;
			uniform float _TimeSpeed;
			uniform float _AmplitudeX;
			uniform float _FrequencyY;
			uniform float _AmplitudeY;
			uniform float4 _WaterColor;
			uniform float4 _FoamColor;
			uniform float _FoamRadius;
			uniform float2 _InteractorUV;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float4 ase_clipPos = UnityObjectToClipPos(IN.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				OUT.ase_texcoord1 = screenPos;
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 texCoord14 = IN.texcoord.xy * float2( 6,2 ) + float2( 0,0 );
				float2 texCoord72 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_75_0 = ( _Time.y * _TimeSpeed );
				float4 screenPos = IN.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 screenColor46 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( sin( ( ( (texCoord72).x * _FrequencyX ) + temp_output_75_0 ) ) * _AmplitudeX ) + ( sin( ( temp_output_75_0 + ( (texCoord72).x * _FrequencyY ) ) ) * _AmplitudeY ) + (ase_screenPosNorm).xy ));
				float2 texCoord132 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult136 = smoothstep( 0.0 , _FoamRadius , length( ( texCoord132 - _InteractorUV ) ));
				float4 lerpResult140 = lerp( _WaterColor , _FoamColor , ( 1.0 - pow( smoothstepResult136 , 2.53 ) ));
				
				fixed4 c = ( step( (texCoord14).y , ( 0.9065465 + ( sin( ( ( _Time.y + (texCoord14).x ) * 6,28318548202515 ) ) * _WaveHeight ) ) ) * ( screenColor46 * lerpResult140 ) );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
235;73;1225;611;3039.829;835.7585;3.583933;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-1536.363,622.2158;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;90;-1351.717,876.8671;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-1128.125,551.9127;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1180.771,813.8661;Inherit;False;Property;_TimeSpeed;TimeSpeed;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1005.672,649.4059;Inherit;False;Property;_FrequencyX;FrequencyX;4;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1713.195,3.460818;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;74;-1281.876,725.9525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;81;-1139.32,907.7171;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;101.1517,973.6301;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;131;133.2911,1267.175;Inherit;False;Property;_InteractorUV;_InteractorUV;10;0;Create;True;0;0;0;False;0;False;0,0;0.55,0.41;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;93;-1070.075,1042.451;Inherit;False;Property;_FrequencyY;FrequencyY;5;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;32;-1424.071,313.2075;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-835.3135,911.277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-832.4551,553.2407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1383.327,94.06326;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;133;394.1744,1018.851;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-988.0718,728.6666;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;134;638.7652,1018.477;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;637.9025,1246.423;Inherit;False;Property;_FoamRadius;FoamRadius;11;0;Create;True;0;0;0;False;0;False;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-603.0048,883.4921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;35;-1081.047,317.5677;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-1096.852,188.1881;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-628.2449,710.2245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;834.165,1034.077;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;79;-448.2349,712.9804;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;70;-573.2699,1077.083;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;-388.6918,1008.476;Inherit;False;Property;_AmplitudeY;AmplitudeY;6;0;Create;True;0;0;0;False;0;False;0.02;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-425.0917,794.1144;Inherit;False;Property;_AmplitudeX;AmplitudeX;7;0;Create;True;0;0;0;False;0;False;0.02;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-836.9244,223.0816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;85;-422.9948,886.2481;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;34;-657.9144,239.0333;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-272.221,714.5815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;142;1064.65,1032.852;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-246.9818,887.8491;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-727.0775,367.0316;Inherit;False;Property;_WaveHeight;WaveHeight;0;0;Create;True;0;0;0;False;0;False;0.06;0.1;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;88;-211.7258,1086.489;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-346.2876,305.4629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;135;1285.808,1024.081;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;141;314.67,801.0336;Inherit;False;Property;_FoamColor;FoamColor;3;0;Create;True;0;0;0;False;0;False;0.6735849,0.9758211,1,0.7803922;0,0.8605688,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;50;211.1029,603.9123;Inherit;False;Property;_WaterColor;WaterColor;2;0;Create;True;0;0;0;False;0;False;0.2541118,0.7452364,0.7830189,0.7803922;0.2541117,0.7452364,0.7830188,0.7803922;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;87;5.578583,766.7272;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-345.4402,149.5824;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.9065465;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;46;126.062,413.8146;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;140;664.5797,677.0715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;-529.0104,0.8816013;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-28.96974,220.836;Inherit;False;2;2;0;FLOAT;1.75;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;581.2222,423.0646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;40;192.7729,3.098031;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-3627.801,2106.175;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;122;-4027.083,3115.092;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;126;-3562.069,3645.428;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;99;-4031.981,2348.571;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-3979.041,2077.284;Inherit;True;Property;_FlowMap;FlowMap;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;100;-3031.461,2324.452;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;109;-3768.39,2586.905;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;129;-2692.996,3695.338;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-3696.148,2832.191;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;117;-3344.908,2861.083;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;120;-3487.805,3265.639;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;121;-3247.189,3270.01;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;110;-3280.787,2565.886;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;125;-2312.299,2637.051;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;119;-2748.568,3079.361;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;128;-2923.604,3686.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;701.8889,156.5799;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-3525.595,2585.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-3327.044,2231.25;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;-3248.552,3651.697;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-3044.151,2986.158;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;130;-2396.7,3738.953;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;934.6505,153.6708;Float;False;True;-1;2;ASEMaterialInspector;0;8;Water;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;90;0;72;0
WireConnection;73;0;72;0
WireConnection;81;0;90;0
WireConnection;32;0;14;0
WireConnection;83;0;81;0
WireConnection;83;1;93;0
WireConnection;77;0;73;0
WireConnection;77;1;92;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;75;0;74;0
WireConnection;75;1;91;0
WireConnection;134;0;133;0
WireConnection;84;0;75;0
WireConnection;84;1;83;0
WireConnection;37;0;33;0
WireConnection;37;1;32;0
WireConnection;78;0;77;0
WireConnection;78;1;75;0
WireConnection;136;0;134;0
WireConnection;136;2;137;0
WireConnection;79;0;78;0
WireConnection;36;0;37;0
WireConnection;36;1;35;0
WireConnection;85;0;84;0
WireConnection;34;0;36;0
WireConnection;80;0;79;0
WireConnection;80;1;95;0
WireConnection;142;0;136;0
WireConnection;86;0;85;0
WireConnection;86;1;94;0
WireConnection;88;0;70;0
WireConnection;42;0;34;0
WireConnection;42;1;43;0
WireConnection;135;0;142;0
WireConnection;87;0;80;0
WireConnection;87;1;86;0
WireConnection;87;2;88;0
WireConnection;46;0;87;0
WireConnection;140;0;50;0
WireConnection;140;1;141;0
WireConnection;140;2;135;0
WireConnection;15;0;14;0
WireConnection;41;0;45;0
WireConnection;41;1;42;0
WireConnection;52;0;46;0
WireConnection;52;1;140;0
WireConnection;40;0;15;0
WireConnection;40;1;41;0
WireConnection;98;0;97;1
WireConnection;98;1;97;2
WireConnection;100;0;99;0
WireConnection;100;1;101;0
WireConnection;100;2;110;0
WireConnection;129;0;128;0
WireConnection;117;0;116;1
WireConnection;117;1;116;2
WireConnection;121;0;120;0
WireConnection;110;0;123;0
WireConnection;125;0;100;0
WireConnection;125;1;119;0
WireConnection;125;2;130;0
WireConnection;119;0;122;0
WireConnection;119;1;118;0
WireConnection;119;2;121;0
WireConnection;128;0;127;0
WireConnection;48;0;40;0
WireConnection;48;1;52;0
WireConnection;123;0;109;0
WireConnection;101;0;98;0
WireConnection;101;1;99;0
WireConnection;127;0;126;0
WireConnection;118;0;117;0
WireConnection;118;1;122;0
WireConnection;130;0;129;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=2753FD16FFC60432B5F6CD7DDA81FC1D6F1DE734