// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprite2D_Water"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_WaveHeight("WaveHeight", Range( 0 , 0.2)) = 0.06
		_LinearSpeed("LinearSpeed", Float) = 2
		_Float2("Float 2", Range( 0 , 4)) = 0.931611
		_WATERheight("WATERheight", Range( 0 , 1)) = 0.9065465
		_WaterColor("WaterColor", Color) = (0.4681273,0.4481132,1,0.7803922)
		_WaterLevel("WaterLevel", Range( 0 , 0.2)) = 0.2
		_SplashAmount("SplashAmount", Range( 0 , 0.2)) = 0.2

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
			uniform float _WaterLevel;
			uniform float _SplashAmount;
			uniform float _WATERheight;
			uniform float _WaveFrequency;
			uniform float _Float2;
			uniform float _WaveHeight;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _LinearSpeed;
			uniform float4 _WaterColor;

			
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

				float2 texCoord231 = IN.texcoord.xy * float2( 6,2 ) + float2( 0,0 );
				float2 texCoord177 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_186_0 = ( _Time.y * _LinearSpeed );
				float4 screenPos = IN.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult226 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				float4 screenColor210 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( sin( ( ( texCoord177.x * 10.0 ) + temp_output_186_0 ) ) * 0.02 ) + ( sin( ( temp_output_186_0 + ( texCoord177.x * 5.0 ) ) ) * 0.02 ) + appendResult226 ));
				
				fixed4 c = ( step( ( ( texCoord231.y + _WaterLevel ) + _SplashAmount ) , ( _WATERheight + ( sin( ( ( texCoord231.x * _WaveFrequency ) + ( _Time.y * ( _Float2 * 6.28318548202515 ) ) ) ) * _WaveHeight ) ) ) * ( screenColor210 * _WaterColor ) );
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
-1920;0;1920;1011;1598.827;388.4332;1.142078;True;False
Node;AmplifyShaderEditor.CommentaryNode;250;-2127.85,-107.5402;Inherit;False;1378.234;671.4102;;19;246;245;231;243;248;247;244;249;234;237;240;242;241;238;239;253;251;254;252;WaveMovement;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;177;-2297.889,696.0172;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;181;-2156.422,959.2482;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-2150.317,1029.162;Inherit;False;Property;_LinearSpeed;LinearSpeed;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-1935.092,379.8509;Inherit;False;Property;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;0.931611;2.39;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;246;-1753.162,449.1193;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-2070.295,1171.897;Inherit;False;Constant;_DistortionY;DistortionY;11;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;225;-2210.425,1042.003;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-2078.218,812.7016;Inherit;False;Constant;_DistortionX;DistortionX;10;0;Create;True;0;0;0;False;0;False;10;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1909.859,1108.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-1917.001,726.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;231;-1828.48,-57.54016;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;6,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;248;-1746.387,267.1213;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-1613.717,428.8701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-2077.85,201.1827;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;2.34;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-1981.618,977.9623;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;-1575.177,299.9354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-1704.551,1045.788;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-1764.378,131.7375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;-1702.791,907.5202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1463.238,1205.771;Inherit;False;Constant;_ScopeY;ScopeY;10;0;Create;True;0;0;0;False;0;False;0.02;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;194;-1574.781,746.2761;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;198;-1574.541,970.5436;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;195;-1445.531,1285.654;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;234;-1549.734,167.9866;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-1408.638,872.4101;Inherit;False;Constant;_ScopeX;ScopeX;11;0;Create;True;0;0;0;False;0;False;0.02;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;237;-1373.716,158.6211;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-1299.767,743.8771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-1604.927,14.82306;Inherit;False;Property;_WaterLevel;WaterLevel;9;0;Create;True;0;0;0;False;0;False;0.2;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;-1387.2,394.1617;Inherit;False;Property;_WaveHeight;WaveHeight;1;0;Create;True;0;0;0;False;0;False;0.06;0.1;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1321.528,1085.145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;226;-1250.448,1277.157;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;-1068.968,964.0229;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-1185.142,80.45513;Inherit;False;Property;_WATERheight;WATERheight;4;0;Create;True;0;0;0;False;0;False;0.9065465;0.9065465;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-1176.042,235.4645;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-1329.701,15.00098;Inherit;False;Property;_SplashAmount;SplashAmount;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;253;-1368.014,-94.0332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-911.0632,164.7747;Inherit;False;2;2;0;FLOAT;1.75;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;210;-948.4843,611.1104;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;209;-742.482,843.9359;Inherit;False;Property;_WaterColor;WaterColor;5;0;Create;True;0;0;0;False;0;False;0.4681273,0.4481132,1,0.7803922;0.2541117,0.7452364,0.7830188,0.7803922;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;254;-1080.224,-99.44525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;241;-907.6152,-49.46018;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-493.3242,620.3604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-704.1945,1567.926;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;191;-235.5812,1542.772;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;184;-741.055,1791.471;Inherit;False;Property;_InteractorUV;_InteractorUV;7;0;Create;True;0;0;0;False;0;False;0,0;0.55,0.41;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;193;-40.18145,1558.373;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;203;208.6617,1311.778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-540.264,101.4763;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;206;-209.7667,1201.367;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-236.4439,1770.719;Inherit;False;Property;_FoamRadius;FoamRadius;8;0;Create;True;0;0;0;False;0;False;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;202;190.3036,1557.148;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;-559.6761,1325.329;Inherit;False;Property;_FoamColor;FoamColor;6;0;Create;True;0;0;0;False;0;False;0.6735849,0.9758211,1,0.7803922;0,0.8605688,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;187;-480.1718,1543.146;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-257.5137,40.08517;Float;False;True;-1;2;ASEMaterialInspector;0;8;Sprite2D_Water;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;225;0;177;1
WireConnection;188;0;225;0
WireConnection;188;1;185;0
WireConnection;208;0;177;1
WireConnection;208;1;180;0
WireConnection;247;0;245;0
WireConnection;247;1;246;0
WireConnection;186;0;181;0
WireConnection;186;1;179;0
WireConnection;249;0;248;0
WireConnection;249;1;247;0
WireConnection;192;0;186;0
WireConnection;192;1;188;0
WireConnection;244;0;231;1
WireConnection;244;1;243;0
WireConnection;189;0;208;0
WireConnection;189;1;186;0
WireConnection;194;0;189;0
WireConnection;198;0;192;0
WireConnection;234;0;244;0
WireConnection;234;1;249;0
WireConnection;237;0;234;0
WireConnection;201;0;194;0
WireConnection;201;1;197;0
WireConnection;199;0;198;0
WireConnection;199;1;196;0
WireConnection;226;0;195;1
WireConnection;226;1;195;2
WireConnection;205;0;201;0
WireConnection;205;1;199;0
WireConnection;205;2;226;0
WireConnection;240;0;237;0
WireConnection;240;1;238;0
WireConnection;253;0;231;2
WireConnection;253;1;251;0
WireConnection;242;0;239;0
WireConnection;242;1;240;0
WireConnection;210;0;205;0
WireConnection;254;0;253;0
WireConnection;254;1;252;0
WireConnection;241;0;254;0
WireConnection;241;1;242;0
WireConnection;176;0;210;0
WireConnection;176;1;209;0
WireConnection;191;0;187;0
WireConnection;193;0;191;0
WireConnection;193;2;190;0
WireConnection;203;0;202;0
WireConnection;175;0;241;0
WireConnection;175;1;176;0
WireConnection;206;1;204;0
WireConnection;206;2;203;0
WireConnection;202;0;193;0
WireConnection;187;0;183;0
WireConnection;187;1;184;0
WireConnection;0;0;175;0
ASEEND*/
//CHKSM=1BBD1AE40693DBC5DB0040EF614F2CFAAC0260A4