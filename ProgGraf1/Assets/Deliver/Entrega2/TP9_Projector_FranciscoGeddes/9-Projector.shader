// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "9-Projector"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (0,1,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float0("Float 0", Float) = 10
		_Float1("Float 1", Range( 0 , 5)) = 5
		_Color0("Color 0", Color) = (0,0.8584906,0.5700275,0)
		_tiling("tiling", Vector) = (0,0,0,0)
		_offset("offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float3 _Vector0;
			uniform float _Float0;
			uniform float _Float1;
			uniform float4 _Color0;
			uniform sampler2D _TextureSample0;
			uniform float2 _tiling;
			uniform float2 _offset;
			uniform sampler2D _TextureSample2;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv_Texture0 = v.ase_texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( tex2Dlod( _Texture0, float4( uv_Texture0, 0, 0.0) ) * float4( _Vector0 , 0.0 ) * _Float0 ).rgb;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord4 = i.ase_texcoord1.xy * _tiling + _offset;
				float2 panner7 = ( 1.0 * _Time.y * float2( -0.02,0.04 ) + texCoord4);
				float2 panner6 = ( 1.0 * _Time.y * float2( 0.03,0.01 ) + texCoord4);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float dotResult12 = dot( ase_worldNormal , float3(0,1,0) );
				
				
				finalColor = ( _Float1 * ( _Color0 * ( tex2D( _TextureSample0, panner7 ) * tex2D( _TextureSample2, panner6 ) ) ) * saturate( dotResult12 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
242;73;1284;614;1826.16;695.7036;1.909498;True;False
Node;AmplifyShaderEditor.Vector2Node;1;-1866.112,-128.2485;Inherit;False;Property;_offset;offset;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;2;-1866.411,-254.7472;Inherit;False;Property;_tiling;tiling;7;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;3;-1644.307,-408.759;Inherit;False;Constant;_speed2;speed2;2;0;Create;True;0;0;0;False;0;False;-0.02,0.04;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1672.132,-275.6173;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-1610.046,-50.99671;Inherit;False;Constant;_speed;speed;2;0;Create;True;0;0;0;False;0;False;0.03,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;6;-1416.965,-69.66291;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;7;-1413.344,-330.2346;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;11;-834.545,-51.2447;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;9;-800.1399,98.46822;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;10;-1163.927,-358.1613;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;ecc1f0de13b0bbe47b4578ee3e3a6b46;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1187.932,-99.21768;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;ecc1f0de13b0bbe47b4578ee3e3a6b46;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;13;-999.1903,269.5343;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DotProductOpNode;12;-594.4642,26.31092;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-805.9379,-405.5382;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0.8584906,0.5700275,0;0,0.8584906,0.5700275,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-797.6735,-183.5206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-757.9793,269.5343;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-552.1639,-302.5277;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-455.5467,26.60984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-550.5363,-206.3065;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-447.0808,508.1638;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-465.8204,337.2806;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-255.1277,275.8598;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-256.8588,-232.1393;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3.818997,-1.909498;Float;False;True;-1;2;ASEMaterialInspector;100;1;9-Projector;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;4;0;2;0
WireConnection;4;1;1;0
WireConnection;6;0;4;0
WireConnection;6;2;5;0
WireConnection;7;0;4;0
WireConnection;7;2;3;0
WireConnection;10;1;7;0
WireConnection;8;1;6;0
WireConnection;12;0;11;0
WireConnection;12;1;9;0
WireConnection;14;0;10;0
WireConnection;14;1;8;0
WireConnection;19;0;13;0
WireConnection;16;0;12;0
WireConnection;17;0;15;0
WireConnection;17;1;14;0
WireConnection;22;0;19;0
WireConnection;22;1;20;0
WireConnection;22;2;18;0
WireConnection;23;0;21;0
WireConnection;23;1;17;0
WireConnection;23;2;16;0
WireConnection;0;0;23;0
WireConnection;0;1;22;0
ASEEND*/
//CHKSM=73B8E427774CDC4073B6BF72981400B50984F17C