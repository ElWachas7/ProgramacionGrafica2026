// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "IntersectionEffect"
{
	Properties
	{
		_WaveCount("WaveCount", Float) = 20
		_ImpactUV("_ImpactUV", Vector) = (0.5,0.5,0,0)
		_WaveSpeed("WaveSpeed", Float) = 15
		_PowerValue("PowerValue", Float) = 10
		_RippleSpeed("RippleSpeed", Float) = 3
		_RippleTime("_RippleTime", Float) = 1
		_NoiseScale("NoiseScale", Float) = 23.8
		_ScreenEmissionIntensity("ScreenEmissionIntensity", Float) = 1
		_RippleEmissionIntensity("RippleEmissionIntensity", Float) = 1
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

		uniform float _RippleTime;
		uniform float _RippleSpeed;
		uniform float4 _ImpactUV;
		uniform float _PowerValue;
		uniform float _RippleEmissionIntensity;
		uniform float _WaveSpeed;
		uniform float _WaveCount;
		uniform float4 _ScreenColour;
		uniform float _NoiseScale;
		uniform float _ScreenEmissionIntensity;


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
			float4 color54 = IsGammaSpace() ? float4(0.8537736,1,0.9629161,0) : float4(0.6990172,1,0.9177046,0);
			float temp_output_66_0 = sin( ( ( _Time.y * _WaveSpeed ) + ( i.uv_texcoord.x * _WaveCount ) ) );
			float simplePerlin2D75 = snoise( ( i.uv_texcoord * temp_output_66_0 )*_NoiseScale );
			simplePerlin2D75 = simplePerlin2D75*0.5 + 0.5;
			o.Emission = ( ( ( pow( saturate( ( 1.0 - abs( ( ( _RippleTime * _RippleSpeed ) - distance( float4( i.uv_texcoord, 0.0 , 0.0 ) , _ImpactUV ) ) ) ) ) , _PowerValue ) * color54 ) * _RippleEmissionIntensity ) + ( ( ( ( abs( temp_output_66_0 ) * 0.16 ) * _ScreenColour ) * simplePerlin2D75 ) * _ScreenEmissionIntensity ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
223;73;608;610;-2021.346;-198.4435;1.288971;False;False
Node;AmplifyShaderEditor.CommentaryNode;58;245.1529,641.083;Inherit;False;1325.714;456.2826;Creación de las ondas;12;74;71;70;69;66;65;64;63;62;61;60;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;60;445.9059,691.0829;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;291.5978,872.6445;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;494.512,769.5646;Inherit;False;Property;_WaveSpeed;WaveSpeed;2;0;Create;True;0;0;0;False;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;332.314,1012.051;Inherit;False;Property;_WaveCount;WaveCount;0;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;1041.285,175.199;Inherit;False;Property;_RippleTime;_RippleTime;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;588.067,935.6461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;687.438,732.3171;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;27;960.5146,-59.71584;Inherit;False;Property;_ImpactUV;_ImpactUV;1;0;Create;True;0;0;0;False;0;False;0.5,0.5,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;1053.065,282.212;Inherit;False;Property;_RippleSpeed;RippleSpeed;4;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;922.2212,-288.8525;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;875.7212,834.7206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;46;1312.862,-74.87894;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1255.13,197.7503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;1457.195,84.42226;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;66;1007.969,835.3586;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;67;1127.452,1100.188;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;50;1612.221,94.04451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1208.125,963.6129;Inherit;False;Constant;_Strength;Strength;0;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;68;952.6899,1170.092;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;1748.693,103.6909;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;70;1223.502,845.4889;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1718.882,240.628;Inherit;False;Property;_PowerValue;PowerValue;3;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;74;1358.489,1049.008;Inherit;False;Property;_ScreenColour;ScreenColour;9;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1098487,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;1045.12,1356.534;Inherit;False;Property;_NoiseScale;NoiseScale;6;0;Create;True;0;0;0;False;0;False;23.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1383.207,861.8252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;57;1894.077,-4.422832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1018.419,1222.877;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;75;1245.53,1304.079;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;1879.252,366.7857;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0.8537736,1,0.9629161,0;0.8537736,1,0.9629161,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1632.27,912.3456;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;52;1952.849,192.8578;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;1918.947,1208.421;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;1906.725,1496.802;Inherit;False;Property;_ScreenEmissionIntensity;ScreenEmissionIntensity;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;2142.12,217.1069;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;2313.911,580.0232;Inherit;False;Property;_RippleEmissionIntensity;RippleEmissionIntensity;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;2208.577,1409.445;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;2667.44,384.054;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;2829.78,989.681;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;3001.676,721.3026;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3269.075,682.2571;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;IntersectionEffect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;62;1
WireConnection;63;1;59;0
WireConnection;64;0;60;0
WireConnection;64;1;61;0
WireConnection;65;0;64;0
WireConnection;65;1;63;0
WireConnection;46;0;45;0
WireConnection;46;1;27;0
WireConnection;47;0;28;0
WireConnection;47;1;48;0
WireConnection;49;0;47;0
WireConnection;49;1;46;0
WireConnection;66;0;65;0
WireConnection;67;0;66;0
WireConnection;50;0;49;0
WireConnection;68;0;67;0
WireConnection;51;0;50;0
WireConnection;70;0;66;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;57;0;51;0
WireConnection;72;0;62;0
WireConnection;72;1;68;0
WireConnection;75;0;72;0
WireConnection;75;1;73;0
WireConnection;76;0;71;0
WireConnection;76;1;74;0
WireConnection;52;0;57;0
WireConnection;52;1;53;0
WireConnection;77;0;76;0
WireConnection;77;1;75;0
WireConnection;55;0;52;0
WireConnection;55;1;54;0
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;82;0;55;0
WireConnection;82;1;81;0
WireConnection;83;0;82;0
WireConnection;83;1;79;0
WireConnection;0;2;83;0
ASEEND*/
//CHKSM=255C398AC8C24DE433BEC10226C8B1ED61512737