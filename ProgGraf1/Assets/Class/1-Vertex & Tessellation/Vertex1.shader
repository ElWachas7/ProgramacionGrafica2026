// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vertex1"
{
	Properties
	{
		_Height("Height", 2D) = "white" {}
		_Texture2("Texture 2", 2D) = "white" {}
		_SandHeight("SandHeight", Float) = 0
		_BrickHeight("BrickHeight", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_clampHeight("clampHeight", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture2;
		uniform float4 _Texture2_ST;
		uniform float _BrickHeight;
		uniform sampler2D _Height;
		uniform float4 _Height_ST;
		uniform float _SandHeight;
		uniform float _clampHeight;
		uniform sampler2D _Texture1;
		uniform float4 _Texture1_ST;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;


		float2 voronoihash33( float2 p )
		{
			p = p - 43 * floor( p / 43 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi33( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash33( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * ( abs(r.x) + abs(r.y) );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Texture2 = v.texcoord * _Texture2_ST.xy + _Texture2_ST.zw;
			float2 uv_Height = v.texcoord * _Height_ST.xy + _Height_ST.zw;
			float time33 = 2.92;
			float2 coords33 = v.texcoord.xy * 8.04;
			float2 id33 = 0;
			float2 uv33 = 0;
			float fade33 = 0.5;
			float voroi33 = 0;
			float rest33 = 0;
			for( int it33 = 0; it33 <7; it33++ ){
			voroi33 += fade33 * voronoi33( coords33, time33, id33, uv33, 0 );
			rest33 += fade33;
			coords33 *= 2;
			fade33 *= 0.5;
			}//Voronoi33
			voroi33 /= rest33;
			float smoothstepResult37 = smoothstep( 0.0 , 1.0 , voroi33);
			float4 lerpResult36 = lerp( ( tex2Dlod( _Texture2, float4( uv_Texture2, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _BrickHeight ) , ( tex2Dlod( _Height, float4( uv_Height, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _SandHeight ) , smoothstepResult37);
			float4 break16 = lerpResult36;
			float clampResult17 = clamp( break16.g , 0.0 , _clampHeight );
			float4 appendResult18 = (float4(break16.r , clampResult17 , break16.b , 0.0));
			v.vertex.xyz += appendResult18.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float time33 = 2.92;
			float2 coords33 = i.uv_texcoord * 8.04;
			float2 id33 = 0;
			float2 uv33 = 0;
			float fade33 = 0.5;
			float voroi33 = 0;
			float rest33 = 0;
			for( int it33 = 0; it33 <7; it33++ ){
			voroi33 += fade33 * voronoi33( coords33, time33, id33, uv33, 0 );
			rest33 += fade33;
			coords33 *= 2;
			fade33 *= 0.5;
			}//Voronoi33
			voroi33 /= rest33;
			float smoothstepResult37 = smoothstep( 0.0 , 1.0 , voroi33);
			float4 lerpResult30 = lerp( tex2D( _Texture1, uv_Texture1 ) , tex2D( _Texture0, uv_Texture0 ) , smoothstepResult37);
			o.Albedo = lerpResult30.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
242.4;73.6;757.2;531.8;1983.386;1125.001;2.501428;False;False
Node;AmplifyShaderEditor.CommentaryNode;29;-2014.937,513.7147;Inherit;False;798.1511;572.9736;Bricks;5;22;25;24;23;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2025.717,-145.153;Inherit;False;798.1512;572.9734;Sand offset;5;5;6;7;10;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1975.717,-95.15296;Inherit;True;Property;_Height;Height;0;0;Create;True;0;0;0;False;0;False;None;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;22;-1964.937,563.7147;Inherit;True;Property;_Texture2;Texture 2;1;0;Create;True;0;0;0;False;0;False;None;9f8d9d9e60979574ea22974d2e2c08d4;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;10;-1582.181,312.4207;Inherit;False;Property;_SandHeight;SandHeight;2;0;Create;True;0;0;0;False;0;False;0;9.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;7;-1594.263,120.555;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;25;-1571.401,971.2882;Inherit;False;Property;_BrickHeight;BrickHeight;3;0;Create;True;0;0;0;False;0;False;0;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1725.318,569.086;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;24;-1583.483,779.4225;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;6;-1736.098,-89.78158;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;33;-1724.649,-374.8977;Inherit;True;0;2;1;1;7;True;43;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;2.92;False;2;FLOAT;8.04;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1389.966,55.63177;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;37;-1114.576,-263.0519;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1379.186,714.4993;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;36;-1021.963,350.9967;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;21;-842.4985,184.8784;Inherit;False;544.8008;429.5583;Clamp Height;4;19;16;17;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-792.4985,252.3808;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1690.367,-922.8312;Inherit;True;Property;_Texture0;Texture 0;4;0;Create;True;0;0;0;False;0;False;None;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;31;-1816.783,-685.5817;Inherit;True;Property;_Texture1;Texture 1;5;0;Create;True;0;0;0;False;0;False;None;b97db8acddac10d4c867939fcd38e487;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;19;-785.1205,499.0367;Inherit;False;Property;_clampHeight;clampHeight;6;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1463.167,-929.2313;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-1589.583,-691.9819;Inherit;True;Property;_TextureSample3;Texture Sample 3;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;17;-602.782,345.0325;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-1353.505,-396.7498;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;14;-215.706,425.7057;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;13;-173.306,594.5059;Inherit;False;3;0;FLOAT;0.2;False;1;FLOAT;2;False;2;FLOAT;10;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;30;-1015.391,-683.4399;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-458.4976,234.8784;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-48.4148,-27.09477;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Vertex1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;0
WireConnection;6;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;10;0
WireConnection;37;0;33;0
WireConnection;26;0;23;0
WireConnection;26;1;24;0
WireConnection;26;2;25;0
WireConnection;36;0;26;0
WireConnection;36;1;8;0
WireConnection;36;2;37;0
WireConnection;16;0;36;0
WireConnection;12;0;11;0
WireConnection;32;0;31;0
WireConnection;17;0;16;1
WireConnection;17;2;19;0
WireConnection;38;0;33;0
WireConnection;30;0;32;0
WireConnection;30;1;12;0
WireConnection;30;2;37;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;18;2;16;2
WireConnection;0;0;30;0
WireConnection;0;11;18;0
WireConnection;0;14;14;0
ASEEND*/
//CHKSM=B6C8F22572FDBDE9E07E0F2AA48FCB7DDB3C2C61