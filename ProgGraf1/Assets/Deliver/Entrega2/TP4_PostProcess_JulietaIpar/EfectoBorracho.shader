// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EfectoBorracho"
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
				float4 appendResult17 = (float4(( sin( ( ( _Time.y * 1.5 ) + ( ase_screenPosNorm.y * 67.0 ) ) ) * 0.01 ) , 0.0 , 0.0 , 0.0));
				float4 temp_output_18_0 = ( appendResult17 + ase_screenPosNorm );
				float4 temp_cast_0 = (0.002).xxxx;
				float4 appendResult32 = (float4(tex2D( _MainTex, ( temp_output_18_0 - temp_cast_0 ).xy ).r , tex2D( _MainTex, temp_output_18_0.xy ).g , tex2D( _MainTex, ( 0.002 + temp_output_18_0 ).xy ).b , 0.0));
				

				finalColor = appendResult32;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
163;73;938;918;402.9499;771.1458;2.826479;False;False
Node;AmplifyShaderEditor.CommentaryNode;14;-1269.228,-287.713;Inherit;False;944.6161;454.4678;Creación de las ondas;9;1;4;3;6;8;2;7;9;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-1219.228,-80.22486;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1027.61,-25.64992;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-978.8697,-154.0317;Inherit;False;Constant;_WaveSpeed;WaveSpeed;0;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1004.568,50.75478;Inherit;False;Constant;_WaveCount;WaveCount;0;0;Create;True;0;0;0;False;0;False;67;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1007.976,-237.7131;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-819.0132,-25.65;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-805.4435,-196.4789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-658.7596,-147.3752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-293.4208,-183.926;Inherit;False;474.289;281.3989;Reduce la fuerza del efecto y crea un nuevo componente;3;15;17;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-243.4208,-18.52714;Inherit;False;Constant;_Strength;Strength;0;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-522.6121,-141.5372;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-135.4712,-133.926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-383.65,219.8347;Inherit;False;730.1826;276.041;Sumar las ondas al Screen Position y conectarlo al UV de la pantalla, para en lugar de pintar el seno, utilizar esa información para mover dónde se pinta cada píxel;2;18;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;19.8682,-129.7213;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;19;-139.9438,284.8119;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;177.1022,526.112;Inherit;False;Constant;_EffectOffset;EffectOffset;0;0;Create;True;0;0;0;False;0;False;0.002;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;518.6498,210.1869;Inherit;False;593.4435;700.5292;Separás cada color de RGB  moves R a la izq, moves B a la derecha, y dejás G como estaba;7;26;27;25;24;28;34;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;183.7897,263.712;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;11;598.1304,463.7846;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;34;542.8406,514.5154;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;554.8383,700.426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;536.6498,273.2642;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;26;830.4615,677.5161;Inherit;True;Property;_BlueBleeding;BlueBleeding;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;841.693,260.1869;Inherit;True;Property;_RedBleeding;RedBleeding;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;36;1146.363,239.4198;Inherit;False;534.5333;643.4182;Filtrás cada capa de color con Component Mask y lo mezclás con un Append;4;32;29;31;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;25;833.0656,464.1053;Inherit;True;Property;_GreenBleeding;GreenBleeding;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;30;1178.447,524.1626;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;1178.447,289.4198;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;1169.163,749.4379;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;1529.496,475.7884;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-2278.41,775.8829;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1741.59,485.4923;Float;False;True;-1;2;ASEMaterialInspector;0;4;EfectoBorracho;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;0;4;2
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;9;0;2;0
WireConnection;9;1;7;0
WireConnection;10;0;9;0
WireConnection;15;0;10;0
WireConnection;15;1;16;0
WireConnection;17;0;15;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;34;0;18;0
WireConnection;28;0;23;0
WireConnection;28;1;18;0
WireConnection;24;0;18;0
WireConnection;24;1;23;0
WireConnection;26;0;11;0
WireConnection;26;1;28;0
WireConnection;27;0;11;0
WireConnection;27;1;24;0
WireConnection;25;0;11;0
WireConnection;25;1;34;0
WireConnection;30;0;25;2
WireConnection;31;0;27;1
WireConnection;29;0;26;3
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;32;2;29;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=3382EA545BA3B58161A6D5B8045C83821E3B982C