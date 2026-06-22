// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EfectoFlashBang"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float luminance3 = Luminance(tex2DNode2.rgb);
				float4 lerpResult11 = lerp( tex2DNode2 , ( ( pow( luminance3 , 0.05 ) * 0.8 ) + tex2DNode2 ) , saturate( sin( _Time.y ) ));
				

				finalColor = lerpResult11;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
286;73;529;918;358.0353;922.7379;1.3;False;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-766.5757,-326.6079;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;15;-164.7584,-194.6257;Inherit;False;755.2666;341.4218;Aisla el brillo con Luminance y Power, y los intensifica con FlashBangForce;6;8;7;6;3;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-530.9371,-341.3575;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;16;-214.2414,-634.4667;Inherit;False;730.1209;318.3319;Activa y desactiva el flashbang constantemente (el saturate clampea de 1 a 0 para que no vaya a -1);3;12;13;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-111.5117,-32.62361;Inherit;False;Constant;_LightStrength;LightStrength;0;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LuminanceNode;3;-114.7584,-144.6257;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;80.8877,30.79602;Inherit;False;Constant;_FlashBangForce;FlashBangForce;0;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-164.2414,-582.4875;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;9;-196.8289,188.4799;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;4;63.79528,-120.277;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;12;83.15712,-584.4667;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;10;241.4384,198.2194;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;287.1882,-120.2008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;14;326.1795,-433.6349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;438.5082,-109.6397;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;672.4286,-316.2321;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;964.5258,-84.23892;Float;False;True;-1;2;ASEMaterialInspector;0;4;EfectoFlashBang;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;9;0;2;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;12;0;13;0
WireConnection;10;0;9;0
WireConnection;6;0;4;0
WireConnection;6;1;7;0
WireConnection;14;0;12;0
WireConnection;8;0;6;0
WireConnection;8;1;10;0
WireConnection;11;0;2;0
WireConnection;11;1;8;0
WireConnection;11;2;14;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=A0D06CA979610664762C179BB8DD57D066BBA660