// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InfiniteScreenShader"
{
	Properties
	{
		_RotationSpeed("RotationSpeed", Float) = 0
		_WaveCount("WaveCount", Float) = 20
		_InfiniteScreenColour("InfiniteScreenColour", Color) = (1,1,1,0)
		_ZoomSpeed("ZoomSpeed", Float) = 0.5
		_WaveSpeed("WaveSpeed", Float) = 15
		_ZoomValues("ZoomValues", Vector) = (-1,1,0.2,1.04)
		_NoiseScale("NoiseScale", Float) = 23.8
		_EmissionIntensity("EmissionIntensity", Float) = 1
		_ScreenColour("ScreenColour", Color) = (1,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_InfiniteScreenIntensity("InfiniteScreenIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _RotationSpeed;
		uniform float _ZoomSpeed;
		uniform float4 _ZoomValues;
		uniform float4 _InfiniteScreenColour;
		uniform float _InfiniteScreenIntensity;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime15 = _Time.y * _RotationSpeed;
			float cos9 = cos( mulTime15 );
			float sin9 = sin( mulTime15 );
			float2 rotator9 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos9 , -sin9 , sin9 , cos9 )) + float2( 0.5,0.5 );
			float temp_output_98_0 = sin( ( ( _Time.y * _WaveSpeed ) + ( i.uv_texcoord.x * _WaveCount ) ) );
			float simplePerlin2D107 = snoise( ( i.uv_texcoord * temp_output_98_0 )*_NoiseScale );
			simplePerlin2D107 = simplePerlin2D107*0.5 + 0.5;
			o.Albedo = ( ( ( ( 1.0 - tex2D( _TextureSample0, ( ( ( rotator9 - float2( 0.5,0.5 ) ) * (_ZoomValues.z + (sin( ( mulTime15 * _ZoomSpeed ) ) - _ZoomValues.x) * (_ZoomValues.w - _ZoomValues.z) / (_ZoomValues.y - _ZoomValues.x)) ) + float2( 0.5,0.5 ) ) ).a ) * _InfiniteScreenColour ) * _InfiniteScreenIntensity ) + ( ( ( ( abs( temp_output_98_0 ) * 0.16 ) * _ScreenColour ) * simplePerlin2D107 ) * _EmissionIntensity ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
223;73;608;610;1740.832;-1031.198;1.67979;False;False
Node;AmplifyShaderEditor.CommentaryNode;90;-2700.548,884.3167;Inherit;False;1325.714;456.2826;Creación de las ondas;12;106;103;102;101;98;97;96;95;94;93;92;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2117.948,-14.76417;Inherit;False;Property;_RotationSpeed;RotationSpeed;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;88;-1844.073,238.4495;Inherit;False;820.3069;389.6867;Logica de zoom;5;24;23;48;52;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1794.073,308.0363;Inherit;False;Property;_ZoomSpeed;ZoomSpeed;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1872.053,-10.06152;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-2451.189,1012.798;Inherit;False;Property;_WaveSpeed;WaveSpeed;4;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2613.387,1255.284;Inherit;False;Property;_WaveCount;WaveCount;1;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;92;-2499.795,934.3165;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-2654.103,1115.878;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1593.739,288.4495;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2185.499,-186.3447;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;89;-1571.7,-185.9362;Inherit;False;823.0672;340.9639;Logica de rotacion en base al centro;3;19;9;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-2258.263,975.5505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-2357.635,1178.879;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2069.98,1077.954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;48;-1419.05,305.6315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;9;-1326.517,-135.9362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;52;-1550.586,416.1362;Inherit;False;Property;_ZoomValues;ZoomValues;5;0;Create;True;0;0;0;False;0;False;-1,1,0.2,1.04;-1,1,0.2,1.04;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;18;-1211.454,13.70372;Inherit;False;Constant;_CenterZoom;CenterZoom;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;98;-1937.733,1078.592;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-1230.766,315.3926;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1026.173,-51.55421;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;99;-1818.249,1343.421;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-957.2221,281.9623;Inherit;False;Constant;_Recenter;Recenter;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-910.6329,103.8767;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-751.0548,163.9845;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-1737.577,1206.846;Inherit;False;Constant;_Strength;Strength;0;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;102;-1722.199,1088.722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;100;-1993.011,1413.326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1900.581,1599.768;Inherit;False;Property;_NoiseScale;NoiseScale;6;0;Create;True;0;0;0;False;0;False;23.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;86;-614.6391,103.9896;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1927.283,1466.111;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;106;-1587.213,1292.241;Inherit;False;Property;_ScreenColour;ScreenColour;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1098487,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1562.494,1105.058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-1313.432,1155.579;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;107;-1700.172,1547.313;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-497.8887,487.6995;Inherit;False;Property;_InfiniteScreenColour;InfiniteScreenColour;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-306.8591,287.5126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-966.0719,1815.136;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1026.754,1451.654;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-147.4182,462.7461;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-267.4851,729.2315;Inherit;False;Property;_InfiniteScreenIntensity;InfiniteScreenIntensity;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-737.1237,1652.679;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1914.732,-1277.635;Inherit;False;1033.197;374.9839;Efecto de olas;10;64;62;66;65;63;67;68;70;69;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;48.41486,612.5316;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1862.619,-1112.442;Inherit;False;Property;_WavesAmount;WavesAmount;7;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;74;-890.0237,-955.1207;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;62;-1833.89,-1227.635;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1672.689,-1201.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-1489.664,-1225.852;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;44.56812,913.8281;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1203.252,-1216.277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;-1568.452,-924.9363;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1610.483,-1055.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1864.732,-1018.651;Inherit;False;Property;_SinTimeSpeed;SinTimeSpeed;11;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-1353.163,-1227.152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1452.566,-1119.352;Inherit;False;Property;_SinStrengthReducer;SinStrengthReducer;9;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-1042.536,-1216.889;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1559.546,-844.5124;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;270.2614,936.3231;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InfiniteScreenShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;7;0
WireConnection;23;0;15;0
WireConnection;23;1;24;0
WireConnection;96;0;92;0
WireConnection;96;1;93;0
WireConnection;95;0;94;1
WireConnection;95;1;91;0
WireConnection;97;0;96;0
WireConnection;97;1;95;0
WireConnection;48;0;23;0
WireConnection;9;0;10;0
WireConnection;9;2;15;0
WireConnection;98;0;97;0
WireConnection;50;0;48;0
WireConnection;50;1;52;1
WireConnection;50;2;52;2
WireConnection;50;3;52;3
WireConnection;50;4;52;4
WireConnection;19;0;9;0
WireConnection;19;1;18;0
WireConnection;99;0;98;0
WireConnection;20;0;19;0
WireConnection;20;1;50;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;102;0;98;0
WireConnection;100;0;99;0
WireConnection;86;1;22;0
WireConnection;104;0;94;0
WireConnection;104;1;100;0
WireConnection;103;0;102;0
WireConnection;103;1;101;0
WireConnection;108;0;103;0
WireConnection;108;1;106;0
WireConnection;107;0;104;0
WireConnection;107;1;105;0
WireConnection;6;0;86;4
WireConnection;109;0;108;0
WireConnection;109;1;107;0
WireConnection;4;0;6;0
WireConnection;4;1;5;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;113;0;4;0
WireConnection;113;1;114;0
WireConnection;74;0;71;0
WireConnection;62;0;10;0
WireConnection;63;0;62;1
WireConnection;63;1;64;0
WireConnection;67;0;63;0
WireConnection;67;1;65;0
WireConnection;112;0;113;0
WireConnection;112;1;111;0
WireConnection;69;0;68;0
WireConnection;69;1;70;0
WireConnection;73;0;74;0
WireConnection;65;0;15;0
WireConnection;65;1;66;0
WireConnection;68;0;67;0
WireConnection;71;0;69;0
WireConnection;72;0;10;0
WireConnection;72;1;73;0
WireConnection;0;0;112;0
ASEEND*/
//CHKSM=73E83E1D5873600C29D886B92B1AFBF8EBF72098