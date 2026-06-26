// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water_Shader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_WaveAmplitude("Wave Amplitude", Range( 0 , 3)) = 0
		_TimeSpeed("TimeSpeed", Float) = 2
		_WaterColor("WaterColor", Color) = (0.2541118,0.7452364,0.7830189,0.7803922)
		_FrequencyX("FrequencyX", Float) = 8
		_FoamColor("FoamColor", Color) = (0.6735849,0.9758211,1,0.7803922)
		_WaveSpeed("Wave Speed", Range( 0 , 4)) = 0.931611
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
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _WaveFrequency;
			uniform float _WaveSpeed;
			uniform float _WaveAmplitude;
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
				OUT.ase_texcoord2 = screenPos;
				
				OUT.ase_texcoord1 = IN.vertex;
				
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

				float2 texCoord3 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime9 = _Time.y * 0.3779937;
				float4 appendResult21 = (float4(0.0 , 0.0 , ( ( sin( ( ( texCoord3.x * _WaveFrequency ) + ( mulTime9 * ( _WaveSpeed * 6.28318548202515 ) ) ) ) * _WaveAmplitude ) * ( 1.0 - saturate( ( IN.ase_texcoord1.xyz.z - 3.0 ) ) ) ) , 0.0));
				float4 WaveMovement22 = appendResult21;
				float2 texCoord30 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_37_0 = ( _Time.y * _TimeSpeed );
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 screenColor45 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( sin( ( ( (texCoord30).x * _FrequencyX ) + temp_output_37_0 ) ) * _AmplitudeX ) + ( sin( ( temp_output_37_0 + ( (texCoord30).x * _FrequencyY ) ) ) * _AmplitudeY ) + (ase_screenPosNorm).xy ));
				float2 texCoord54 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult57 = smoothstep( 0.0 , _FoamRadius , length( ( texCoord54 - _InteractorUV ) ));
				float4 lerpResult49 = lerp( _WaterColor , _FoamColor , ( 1.0 - pow( smoothstepResult57 , 2.53 ) ));
				
				fixed4 c = ( WaveMovement22 * ( screenColor45 * lerpResult49 ) );
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
180;73;1393;647;1882.935;-208.5835;1.796912;True;False
Node;AmplifyShaderEditor.CommentaryNode;46;-1762.332,455.4023;Inherit;False;1703.263;729.2972;distorsion del agua;23;34;25;32;37;38;44;30;36;35;31;23;24;26;33;40;42;39;43;41;27;28;29;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-1599.082,-215.4149;Inherit;False;1539.354;634.1166;;21;22;21;20;19;18;17;16;15;14;13;12;11;10;9;8;7;6;5;4;3;2;Wave Movement;0.6933962,0.9097468,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1712.332,505.4023;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TauNode;5;-1464.404,261.2095;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1543.12,103.7017;Inherit;False;Constant;_LinearSpeed;LinearSpeed;13;0;Create;True;0;0;0;False;0;False;0.3779937;0.249;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;23;-1456.914,628.4838;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1368.01,-126.9655;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1549.082,175.053;Inherit;False;Property;_WaveSpeed;Wave Speed;6;0;Create;True;0;0;0;False;0;False;0.931611;2.39;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;34;-1431.322,527.5294;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1226.12,116.7018;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1266.45,218.4506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1523.275,677.6849;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1219.574,13.09979;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;2.34;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-1143.574,-91.9002;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1316.272,926.0676;Inherit;False;Property;_FrequencyY;FrequencyY;7;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;-1511.517,859.3338;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-414.8407,1197.889;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;53;-388.3127,1321.618;Inherit;False;Property;_InteractorUV;_InteractorUV;10;0;Create;True;0;0;0;False;0;False;0,0;0.55,0.41;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;35;-1515.642,750.0198;Inherit;False;Property;_TimeSpeed;TimeSpeed;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1335.869,598.0225;Inherit;False;Property;_FrequencyX;FrequencyX;4;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1007.91,120.516;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1165.511,859.8936;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1166.652,542.8574;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1318.269,677.2833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-964.5718,-106.9003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-810.97,-147.871;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-193.2642,1217.129;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-958.442,657.8411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-824.5176,29.86822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-627.8812,-133.8217;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-958.2019,747.1088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-16.15736,1336.701;Inherit;False;Property;_FoamRadius;FoamRadius;11;0;Create;True;0;0;0;False;0;False;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;56;-50.43047,1212.425;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-721.8181,314.3513;Inherit;False;Property;_WaveAmplitude;Wave Amplitude;1;0;Create;True;0;0;0;False;0;False;0;0.73;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;40;-786.4323,672.5971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-710.8892,887.0927;Inherit;False;Property;_AmplitudeY;AmplitudeY;8;0;Create;True;0;0;0;False;0;False;0.02;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-798.2891,742.731;Inherit;False;Property;_AmplitudeX;AmplitudeX;9;0;Create;True;0;0;0;False;0;False;0.02;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;39;-811.9277,783.5354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-498.8815,-135.8217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;27;-898.4672,972.6995;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;57;144.9695,1202.044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;17;-694.5172,48.86823;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-602.4183,663.1982;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-607.1791,796.4658;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-364.2182,-132.5761;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;301.8431,1196.489;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-491.0041,-3.943667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;28;-660.9231,973.1055;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-437.6189,714.3438;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;47;-20.20946,772.8959;Inherit;False;Property;_WaterColor;WaterColor;3;0;Create;True;0;0;0;False;0;False;0.2541118,0.7452364,0.7830189,0.7803922;0.2541117,0.7452364,0.7830188,0.7803922;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;83.35791,970.0176;Inherit;False;Property;_FoamColor;FoamColor;5;0;Create;True;0;0;0;False;0;False;0.6735849,0.9758211,1,0.7803922;0,0.8605688,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;60;471.0403,1176.893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-250.2182,-47.57618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;45;-255.0691,653.7065;Inherit;False;Global;_GrabScreen0;Grab Screen 0;8;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;49;284.9763,787.6069;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-437.3532,115.011;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;37.62371,605.3242;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-291.7275,155.5223;Inherit;False;WaveMovement;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;161.5706,390.6285;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;603.8155,-39.8746;Float;False;True;-1;2;ASEMaterialInspector;0;8;Water_Shader;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;30;0
WireConnection;34;0;30;0
WireConnection;9;0;4;0
WireConnection;6;0;2;0
WireConnection;6;1;5;0
WireConnection;7;0;3;1
WireConnection;31;0;23;0
WireConnection;10;0;9;0
WireConnection;10;1;6;0
WireConnection;25;0;31;0
WireConnection;25;1;24;0
WireConnection;33;0;34;0
WireConnection;33;1;32;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;12;0;7;0
WireConnection;12;1;8;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;38;0;33;0
WireConnection;38;1;37;0
WireConnection;13;0;12;0
WireConnection;13;1;10;0
WireConnection;14;0;11;3
WireConnection;26;0;37;0
WireConnection;26;1;25;0
WireConnection;56;0;55;0
WireConnection;40;0;38;0
WireConnection;39;0;26;0
WireConnection;15;0;14;0
WireConnection;57;0;56;0
WireConnection;57;2;58;0
WireConnection;17;0;13;0
WireConnection;44;0;40;0
WireConnection;44;1;42;0
WireConnection;43;0;39;0
WireConnection;43;1;41;0
WireConnection;18;0;15;0
WireConnection;59;0;57;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;28;0;27;0
WireConnection;29;0;44;0
WireConnection;29;1;43;0
WireConnection;29;2;28;0
WireConnection;60;0;59;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;45;0;29;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;49;2;60;0
WireConnection;21;2;20;0
WireConnection;51;0;45;0
WireConnection;51;1;49;0
WireConnection;22;0;21;0
WireConnection;52;0;22;0
WireConnection;52;1;51;0
WireConnection;0;0;52;0
ASEEND*/
//CHKSM=5B93A6491E6255BF0D57A8BF2F5B756901194C7C