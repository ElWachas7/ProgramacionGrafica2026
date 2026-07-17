// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SunnyPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Brightness("Brightness", Range( 0 , 2)) = 1.1
		_SunnyColor("SunnyColor", Color) = (0.9932242,1,0.7311321,0)
		_RayFrequency("RayFrequency", Range( 0 , 20)) = 2
		_RaySpeed("RaySpeed", Range( 0.1 , 2)) = 0.5
		_RayColor("RayColor", Color) = (1,0.9928446,0.2877358,0)
		_RayIntensity("RayIntensity", Range( 0 , 1)) = 0.7

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
			
			uniform float _Brightness;
			uniform float4 _SunnyColor;
			uniform float _RayFrequency;
			uniform float _RaySpeed;
			uniform float4 _RayColor;
			uniform float _RayIntensity;


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
				float2 texCoord5 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord14 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult25 = smoothstep( 0.0 , 1.0 , ( ( sin( ( ( (texCoord14).x * _RayFrequency ) + ( _Time.y * _RaySpeed ) ) ) * 0.5 ) + 0.5 ));
				

				finalColor = ( ( ( tex2D( _MainTex, texCoord5 ) * _Brightness ) * _SunnyColor ) + ( ( smoothstepResult25 * _RayColor ) * _RayIntensity ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
142;73;1322;607;3526.325;1833.857;3.482587;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2124.117,-1102.908;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1574.055,-725.298;Inherit;False;Property;_RaySpeed;RaySpeed;3;0;Create;True;0;0;0;False;0;False;0.5;0;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;-1867.916,-1064.062;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1913.659,-879.4265;Inherit;False;Property;_RayFrequency;RayFrequency;2;0;Create;True;0;0;0;False;0;False;2;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1455.985,-841.228;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1629.985,-949.2281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1256.985,-782.2281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1123.985,-920.228;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;22;-934.9183,-913.8321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;16;-949.0974,-393.3036;Inherit;False;1092.491;835.0872;Main Color;7;5;10;7;9;6;4;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-760.242,-910.5995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-586.4722,-914.9523;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-868.5182,-143.7346;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;3;-818.7862,-240.351;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;-428.0111,-778.169;Inherit;False;Property;_RayColor;RayColor;4;0;Create;True;0;0;0;False;0;False;1,0.9928446,0.2877358,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-532.3636,56.534;Inherit;False;Property;_Brightness;Brightness;0;0;Create;True;0;0;0;False;0;False;1.1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-560.4865,-220.151;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;25;-388.9117,-929.9976;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-96.01152,-853.169;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0.5,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-139.0115,-676.169;Inherit;False;Property;_RayIntensity;RayIntensity;5;0;Create;True;0;0;0;False;0;False;0.7;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-214.3639,-41.46604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-246.364,120.134;Inherit;False;Property;_SunnyColor;SunnyColor;1;0;Create;True;0;0;0;False;0;False;0.9932242,1,0.7311321,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;216.9887,-846.169;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;17.63596,6.533992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;322.0861,-342.1061;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;595.4063,-147.44;Float;False;True;-1;2;ASEMaterialInspector;0;4;SunnyPostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;15;0;14;0
WireConnection;17;0;15;0
WireConnection;17;1;13;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;21;0;17;0
WireConnection;21;1;20;0
WireConnection;22;0;21;0
WireConnection;23;0;22;0
WireConnection;24;0;23;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;25;0;24;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;10;0;7;0
WireConnection;10;1;9;0
WireConnection;30;0;10;0
WireConnection;30;1;29;0
WireConnection;0;0;30;0
ASEEND*/
//CHKSM=B7ECDC3210A52AD004B3E7A01AA0E1A7B9BA77CB