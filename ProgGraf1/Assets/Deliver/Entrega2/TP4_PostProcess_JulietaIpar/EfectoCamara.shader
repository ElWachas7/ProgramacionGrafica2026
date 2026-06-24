// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EfectoCamara"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		
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
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
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
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 color15 = IsGammaSpace() ? float4(0,0.5188679,0.1920335,0) : float4(0,0.2319225,0.03067667,0);
				float2 texCoord19 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult23 = smoothstep( 0.3 , 0.7 , length( ( texCoord19 - float2( 0.5,0.5 ) ) ));
				float4 color29 = IsGammaSpace() ? float4(0,1,0.5567567,0) : float4(0,1,0.2703853,0);
				float4 lerpResult33 = lerp( ( ( ( ( abs( sin( ( ( _Time.y * 16.9 ) + ( ase_screenPosNorm.y * 29.28 ) ) ) ) * 0.16 ) * color15 ) + tex2D( _MainTex, texCoord19 ) ) * ( 1.0 - smoothstepResult23 ) ) , color29 , 0.3080571);
				float luminance39 = Luminance(lerpResult33.rgb);
				float4 lerpResult43 = lerp( lerpResult33 , ( lerpResult33 * 0.25 ) , ( 1.0 - luminance39 ));
				

				finalColor = lerpResult43;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
685;81;523;909;-1050.715;1162.979;3.238443;False;False
Node;AmplifyShaderEditor.CommentaryNode;13;-1060.867,-466.8663;Inherit;False;944.6161;454.4678;Creación de las ondas;9;12;11;10;9;8;7;6;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-1012.867,-259.3782;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;5;-821.249,-204.8035;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-772.5086,-333.185;Inherit;False;Constant;_WaveSpeed;WaveSpeed;0;0;Create;True;0;0;0;False;0;False;16.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-798.207,-128.3988;Inherit;False;Constant;_WaveCount;WaveCount;0;0;Create;True;0;0;0;False;0;False;29.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-801.615,-416.8664;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-612.6521,-204.8035;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-599.0824,-375.6322;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-452.3987,-326.5285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;-227.4443,60.884;Inherit;False;736.3922;604.0964;Efecto de vignette para la cámara;7;2;24;22;25;1;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-253.5386,266.7319;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-73.36185,455.6979;Inherit;False;Constant;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;12;-316.2511,-320.6905;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-59.39077,-427.9537;Inherit;False;684.7938;419.2203;Se agrega color a las líneas del seno;5;16;18;17;15;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;89.16168,-300.3592;Inherit;False;Constant;_Strength;Strength;0;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;89.23671,332.6496;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;18;-9.390791,-377.9537;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;22;282.5974,332.6499;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-58.68886,116.0401;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;200.3453,523.2526;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;250.1643,-369.3367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;200.3453,430.9677;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;158.1269,-220.7334;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.5188679,0.1920335,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;463.4032,-340.545;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;426.6649,327.6958;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;109.984,110.884;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;26;598.9183,190.3185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;530.4232,45.19801;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;60;807.5812,-18.90771;Inherit;False;383.4172;465.1853;Color a la pantalla general;3;33;34;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;29;808.4257,145.5501;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;0,1,0.5567567,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;850.0644,325.3621;Inherit;False;Constant;_Float2;Float 2;0;0;Create;True;0;0;0;False;0;False;0.3080571;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;682.813,25.8537;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;33;1054.877,31.09229;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;56;1255.447,-75.69264;Inherit;False;763.834;417.7968;Aumentar contraste de sombras (estilo Outlast);6;39;50;41;28;43;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LuminanceNode;39;1317.128,-33.9209;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;1329.331,185.0613;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;1402.326,166.3223;Inherit;False;Constant;_ContrastStrength;ContrastStrength;0;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1657.263,65.3663;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;50;1581.353,279.5416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;1864.175,-25.69272;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2125.62,148.011;Float;False;True;-1;2;ASEMaterialInspector;0;4;EfectoCamara;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;5;0;4;2
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;6;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;12;0;11;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;18;0;12;0
WireConnection;22;0;20;0
WireConnection;17;0;18;0
WireConnection;17;1;16;0
WireConnection;14;0;17;0
WireConnection;14;1;15;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;23;2;25;0
WireConnection;2;0;1;0
WireConnection;2;1;19;0
WireConnection;26;0;23;0
WireConnection;3;0;14;0
WireConnection;3;1;2;0
WireConnection;27;0;3;0
WireConnection;27;1;26;0
WireConnection;33;0;27;0
WireConnection;33;1;29;0
WireConnection;33;2;34;0
WireConnection;39;0;33;0
WireConnection;58;0;39;0
WireConnection;28;0;33;0
WireConnection;28;1;41;0
WireConnection;50;0;58;0
WireConnection;43;0;33;0
WireConnection;43;1;28;0
WireConnection;43;2;50;0
WireConnection;0;0;43;0
ASEEND*/
//CHKSM=29CA5BDAA9F05685C92B2DAF9848CA45A66F90FB