// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StaticTVShader"
{
	Properties
	{
		_WaveCount("WaveCount", Float) = 20
		_WaveSpeed("WaveSpeed", Float) = 15
		_NoiseScale("NoiseScale", Float) = 23.8
		_EmissionIntensity("EmissionIntensity", Float) = 1
		_ScreenColour("ScreenColour", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _WaveSpeed;
		uniform float _WaveCount;
		uniform float4 _ScreenColour;
		uniform float _NoiseScale;
		uniform float _EmissionIntensity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_9_0 = sin( ( ( _Time.y * _WaveSpeed ) + ( i.uv_texcoord.x * _WaveCount ) ) );
			float simplePerlin2D18 = snoise( ( i.uv_texcoord * temp_output_9_0 )*_NoiseScale );
			simplePerlin2D18 = simplePerlin2D18*0.5 + 0.5;
			o.Emission = ( ( ( ( abs( temp_output_9_0 ) * 0.16 ) * _ScreenColour ) * simplePerlin2D18 ) * _EmissionIntensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
158;73;679;717;1765.948;646.9832;3.63992;False;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1399.929,-176.9324;Inherit;False;1325.714;456.2826;Creación de las ondas;11;12;10;11;9;8;7;6;5;4;2;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1312.768,194.0352;Inherit;False;Property;_WaveCount;WaveCount;0;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1199.176,-126.9325;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1150.57,-48.45099;Inherit;False;Property;_WaveSpeed;WaveSpeed;1;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1353.484,54.62903;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1057.015,117.6306;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-957.6441,-85.69833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-769.3608,16.7051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-637.1132,17.3431;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;26;-517.6301,282.1722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;11;-421.5801,27.47343;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-436.9572,145.5974;Inherit;False;Constant;_Strength;Strength;0;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;25;-692.392,352.077;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-261.8752,43.80972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-626.6635,404.8625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-599.9622,538.5192;Inherit;False;Property;_NoiseScale;NoiseScale;2;0;Create;True;0;0;0;False;0;False;23.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-286.5934,230.9924;Inherit;False;Property;_ScreenColour;ScreenColour;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1098487,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-399.5527,486.064;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-12.81254,94.33007;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;273.8653,390.4056;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;243.5472,709.887;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;563.4952,591.43;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;863.0168,360.1444;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;StaticTVShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;13;1
WireConnection;7;1;2;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;26;0;9;0
WireConnection;11;0;9;0
WireConnection;25;0;26;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;21;0;13;0
WireConnection;21;1;25;0
WireConnection;18;0;21;0
WireConnection;18;1;19;0
WireConnection;23;0;12;0
WireConnection;23;1;24;0
WireConnection;20;0;23;0
WireConnection;20;1;18;0
WireConnection;30;0;20;0
WireConnection;30;1;31;0
WireConnection;0;2;30;0
ASEEND*/
//CHKSM=42DBDCC31ACECD9900A291DBC58C85CE90E0FD62