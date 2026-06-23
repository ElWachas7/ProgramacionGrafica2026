// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InteractableWater"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_DistortionSpeed("Distortion Speed", Vector) = (0,0,0,0)
		_ImpactPosition("ImpactPosition", Vector) = (0,0,0,0)
		_WaterNormal("WaterNormal", 2D) = "white" {}
		_WaterTexture("WaterTexture", 2D) = "black" {}
		_WaveAmplitude("Wave Amplitude", Range( 0 , 4)) = 2.42703
		_DistortionAmount("Distortion Amount", Range( 0 , 4)) = 2.42703
		_WaveSpeed("Wave Speed", Range( 0 , 4)) = 0.931611

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
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
			#include "UnityStandardUtils.cginc"
			#define ASE_NEEDS_VERT_POSITION


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
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _WaveFrequency;
			uniform float _WaveSpeed;
			uniform float _WaveAmplitude;
			uniform float3 _ImpactPosition;
			uniform sampler2D _WaterTexture;
			uniform sampler2D _WaterNormal;
			uniform float2 _DistortionSpeed;
			uniform float _DistortionAmount;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float2 texCoord7 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime5 = _Time.y * 0.3779937;
				float3 ase_worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				float4 appendResult18 = (float4(0.0 , 0.0 , ( ( ( sin( ( ( texCoord7.x * _WaveFrequency ) + ( mulTime5 * ( _WaveSpeed * 6.28318548202515 ) ) ) ) * _WaveAmplitude ) + sin( ( distance( ase_worldPos , _ImpactPosition ) - _Time.y ) ) ) * ( 1.0 - saturate( ( (IN.vertex.xyz).z - 3.0 ) ) ) ) , 0.0));
				
				
				IN.vertex.xyz += appendResult18.xyz; 
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

				float2 texCoord24 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner26 = ( _Time.y * _DistortionSpeed + texCoord24);
				float2 MainUvs222_g3 = panner26;
				float4 tex2DNode65_g3 = tex2D( _WaterNormal, MainUvs222_g3 );
				float4 appendResult82_g3 = (float4(0.0 , tex2DNode65_g3.g , 0.0 , tex2DNode65_g3.r));
				float2 temp_output_84_0_g3 = (UnpackScaleNormal( appendResult82_g3, _DistortionAmount )).xy;
				float2 temp_output_71_0_g3 = ( temp_output_84_0_g3 + MainUvs222_g3 );
				float4 tex2DNode96_g3 = tex2D( _WaterTexture, temp_output_71_0_g3 );
				float4 break34 = tex2DNode96_g3;
				float4 appendResult35 = (float4(break34.r , break34.g , break34.b , 0.3));
				
				fixed4 c = appendResult35;
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
546;221;1245;511;965.009;-195.6111;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;38;-1197.451,-438.3185;Inherit;False;1486.115;566.7827;;21;13;12;14;7;10;5;8;9;11;6;4;17;16;15;42;43;44;46;47;49;61;Movimiento Olas;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-990.9053,-338.8868;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1134.293,-30.27969;Inherit;False;Property;_WaveSpeed;Wave Speed;14;0;Create;True;0;0;0;False;0;False;0.931611;0.931611;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1147.451,-82.28468;Inherit;False;Constant;_LinearSpeed;LinearSpeed;13;0;Create;True;0;0;0;False;0;False;0.3779937;0.249;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;14;-1056.855,-0.5556068;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-835.7809,-6.535728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-778.4514,-73.28467;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-845.905,-230.8868;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-769.905,-335.8868;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;56;-380.801,268.7957;Inherit;False;Property;_ImpactPosition;ImpactPosition;9;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-571.4502,-79.28471;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-377.2993,128.7005;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-555.9039,-291.8869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-920.0148,430.1241;Inherit;False;1291.593;801.2841;;10;23;32;22;54;34;35;28;27;24;26;Textura y su movimiento;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-442.912,-404.4014;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;28;-589.2534,1120.408;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-277.2134,-405.8083;Inherit;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-416.8497,-216.1183;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;58;-193.8452,198.8015;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-870.0148,889.4601;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-31.8455,189.8014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-804.1679,1011.314;Inherit;False;Property;_DistortionSpeed;Distortion Speed;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;17;-392.2575,9.069984;Inherit;False;Property;_WaveAmplitude;Wave Amplitude;12;0;Create;True;0;0;0;False;0;False;2.42703;0.62;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-76.21338,-350.8083;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-289.8497,-218.1183;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;51.78662,-372.8083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-605.5383,678.9871;Inherit;True;Property;_WaterNormal;WaterNormal;10;0;Create;True;0;0;0;False;0;False;None;26da8dec7fccda9429a78e8f26297497;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;32;-582.0067,480.1241;Inherit;True;Property;_WaterTexture;WaterTexture;11;0;Create;True;0;0;0;False;0;False;4d64cb8b52ab7ed41a67554d2df38228;26da8dec7fccda9429a78e8f26297497;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;26;-610.635,883.716;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;60;119.0437,189.896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-325.531,887.5349;Inherit;False;Property;_DistortionAmount;Distortion Amount;13;0;Create;True;0;0;0;False;0;False;2.42703;2.42703;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-28.33613,-188.9301;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;149.7866,-319.8083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;122.3881,-106.0287;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;54;-250.2616,641.3525;Inherit;False;UI-Sprite Effect Layer;1;;3;789bf62641c5cfe4ab7126850acc22b8;18,204,0,74,0,191,0,225,1,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;248.7866,-206.8083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;34;65.70393,692.0361;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;18;435.6637,-117.9301;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;212.178,659.7858;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0.3;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;636,-62;Float;False;True;-1;2;ASEMaterialInspector;0;8;InteractableWater;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;15;0;12;0
WireConnection;15;1;14;0
WireConnection;5;0;13;0
WireConnection;8;0;7;1
WireConnection;11;0;5;0
WireConnection;11;1;15;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;43;0;46;0
WireConnection;6;0;9;0
WireConnection;6;1;11;0
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;59;0;58;0
WireConnection;59;1;28;0
WireConnection;49;0;43;0
WireConnection;4;0;6;0
WireConnection;44;0;49;0
WireConnection;26;0;24;0
WireConnection;26;2;27;0
WireConnection;26;1;28;0
WireConnection;60;0;59;0
WireConnection;16;0;4;0
WireConnection;16;1;17;0
WireConnection;47;0;44;0
WireConnection;61;0;16;0
WireConnection;61;1;60;0
WireConnection;54;37;32;0
WireConnection;54;218;26;0
WireConnection;54;75;22;0
WireConnection;54;80;23;0
WireConnection;42;0;61;0
WireConnection;42;1;47;0
WireConnection;34;0;54;0
WireConnection;18;2;42;0
WireConnection;35;0;34;0
WireConnection;35;1;34;1
WireConnection;35;2;34;2
WireConnection;0;0;35;0
WireConnection;0;1;18;0
ASEEND*/
//CHKSM=6F76344C31CF3F3B5A9537ECA3E6521BDD6855DD