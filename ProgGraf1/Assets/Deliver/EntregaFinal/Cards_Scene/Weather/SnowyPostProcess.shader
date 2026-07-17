// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SnowyPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_SnowBrightness("SnowBrightness", Range( 0 , 2)) = 1.1
		_SnowColor("SnowColor", Color) = (0.5188679,0.5188679,0.5188679,0)
		_SnowTexture("SnowTexture", 2D) = "white" {}
		_SnowSpeed("SnowSpeed", Range( 0.2 , 2)) = 0.2

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
			
			uniform sampler2D _SnowTexture;
			uniform float _SnowSpeed;
			uniform float _SnowBrightness;
			uniform float4 _SnowColor;


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
				float2 appendResult13 = (float2(0.1 , _SnowSpeed));
				float2 texCoord10 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner11 = ( 1.0 * _Time.y * appendResult13 + texCoord10);
				float2 texCoord2 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				

				finalColor = ( tex2D( _SnowTexture, panner11 ) + ( ( tex2D( _MainTex, texCoord2 ) * _SnowBrightness ) * _SnowColor ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
198;73;1266;607;1374.658;1149.956;1.59349;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1569.897,-510.1328;Inherit;False;1092.491;835.0872;Main Color;7;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1489.317,-260.5638;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-1439.585,-357.1802;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1413.337,-614.7507;Inherit;False;Property;_SnowSpeed;SnowSpeed;3;0;Create;True;0;0;0;False;0;False;0.2;0;0.2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1397.48,-796.9158;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1119.356,-694.2272;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-1181.286,-336.9802;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1153.163,-60.29518;Inherit;False;Property;_SnowBrightness;SnowBrightness;0;0;Create;True;0;0;0;False;0;False;1.1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-835.1631,-158.2953;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;11;-910.7024,-791.3892;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-867.1633,3.304825;Inherit;False;Property;_SnowColor;SnowColor;1;0;Create;True;0;0;0;False;0;False;0.5188679,0.5188679,0.5188679,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-603.1633,-110.2952;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-660.928,-836.918;Inherit;True;Property;_SnowTexture;SnowTexture;2;0;Create;True;0;0;0;False;0;False;-1;e413796978815dd4fa9635aa87213485;9230fccda3d9747448f776afe97192a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-311.0254,-356.6763;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;36.89887,-362.0703;Float;False;True;-1;2;ASEMaterialInspector;0;4;SnowyPostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;13;1;12;0
WireConnection;3;0;8;0
WireConnection;3;1;2;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;11;0;10;0
WireConnection;11;2;13;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;9;1;11;0
WireConnection;14;0;9;0
WireConnection;14;1;7;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=8A284F6AB638980F0AEC674C9071C7C5544AA5AE