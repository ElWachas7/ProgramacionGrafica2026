// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RainyPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_RainyBrightness("RainyBrightness", Range( 0 , 2)) = 1.1
		_RainyColor("RainyColor", Color) = (0.4116234,0.6179566,0.6981132,0)
		_RainTexture("RainTexture", 2D) = "white" {}
		_RainSpeed("RainSpeed", Range( 2 , 3)) = 2.75

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _RainTexture;
			uniform float _RainSpeed;
			uniform float _RainyBrightness;
			uniform float4 _RainyColor;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 appendResult13 = (float2(0.1 , _RainSpeed));
				float2 texCoord10 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner11 = ( 1.0 * _Time.y * appendResult13 + texCoord10);
				float2 texCoord2 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				

				finalColor = ( tex2D( _RainTexture, panner11 ) + ( ( tex2D( _MainTex, texCoord2 ) * _RainyBrightness ) * _RainyColor ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
198;73;1266;607;1974.013;1136.272;1.700425;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1567.591,-447.8659;Inherit;False;1092.491;835.0872;Main Color;7;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1487.011,-198.2969;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-1437.279,-294.9133;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1195.506,-536.2303;Inherit;False;Property;_RainSpeed;RainSpeed;3;0;Create;True;0;0;0;False;0;False;2.75;0;2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1179.649,-718.3953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1178.98,-274.7133;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1150.857,1.971661;Inherit;False;Property;_RainyBrightness;RainyBrightness;0;0;Create;True;0;0;0;False;0;False;1.1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-901.5246,-615.7068;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-728.3323,-798.9879;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-832.857,-96.02838;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-864.8571,65.57166;Inherit;False;Property;_RainyColor;RainyColor;1;0;Create;True;0;0;0;False;0;False;0.4116234,0.6179566,0.6981132,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-478.5579,-844.5167;Inherit;True;Property;_RainTexture;RainTexture;2;0;Create;True;0;0;0;False;0;False;-1;9230fccda3d9747448f776afe97192a1;9230fccda3d9747448f776afe97192a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-600.8571,-48.02835;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-311.0254,-356.6763;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;4;RainyPostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;8;0
WireConnection;3;1;2;0
WireConnection;13;1;12;0
WireConnection;11;0;10;0
WireConnection;11;2;13;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;9;1;11;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;14;0;9;0
WireConnection;14;1;7;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=72F15984ACD8B3AE6DFFBB1383A5353F6B5E7094