// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InteractableWater"
{
	Properties
	{
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_WaveAmplitude("Wave Amplitude", Range( 0 , 3)) = 0
		_WaveHeight("_WaveHeight", Range( 0 , 5)) = 0
		_WaveSpeed("Wave Speed", Range( 0 , 4)) = 0.931611
		_WaterColor("_WaterColor", Color) = (0,0.2860703,0.6037736,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _WaveFrequency;
		uniform float _WaveSpeed;
		uniform float _WaveAmplitude;
		uniform float4 _WaterColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _WaveHeight;


		float2 voronoihash100( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi100( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash100( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 1.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime5 = _Time.y * 0.3779937;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult18 = (float4(0.0 , 0.0 , ( ( sin( ( ( v.texcoord.xy.x * _WaveFrequency ) + ( mulTime5 * ( _WaveSpeed * 6.28318548202515 ) ) ) ) * _WaveAmplitude ) * ( 1.0 - saturate( ( ase_vertex3Pos.z - 3.0 ) ) ) ) , 0.0));
			float4 WaveMovement139 = appendResult18;
			v.vertex.xyz += WaveMovement139.xyz;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time100 = _Time.y;
			float2 coords100 = i.uv_texcoord * 2.0;
			float2 id100 = 0;
			float2 uv100 = 0;
			float voroi100 = voronoi100( coords100, time100, id100, uv100, 0 );
			float4 color106 = IsGammaSpace() ? float4(0.4009434,0.7876437,1,0) : float4(0.1335305,0.5830954,1,0);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth87 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth87 = abs( ( screenDepth87 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float4 WaveColor138 = ( ( _WaterColor + ( voroi100 * color106 ) ) + saturate( ( 1.0 - pow( ( ( distanceDepth87 + 0.0 ) * 0.0 ) , 0.0 ) ) ) );
			o.Emission = WaveColor138.rgb;
			o.Alpha = ( step( i.uv_texcoord.y , _WaveHeight ) * 0.6 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
175;73;1292;645;1519.733;-345.745;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;143;-1759.272,461.1315;Inherit;False;1539.354;634.1166;;21;7;12;14;13;15;5;8;10;46;9;11;49;6;17;44;4;47;16;42;18;139;Wave Movement;0.6933962,0.9097468,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1703.31,780.2481;Inherit;False;Constant;_LinearSpeed;LinearSpeed;13;0;Create;True;0;0;0;False;0;False;0.3779937;0.249;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;14;-1624.594,937.7559;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1709.272,851.5994;Inherit;False;Property;_WaveSpeed;Wave Speed;3;0;Create;True;0;0;0;False;0;False;0.931611;2.39;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1528.2,549.5809;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;142;-1749.943,-407.6501;Inherit;False;1638.904;806.5594;;18;87;88;102;90;99;106;100;92;94;107;105;95;96;89;91;93;104;138;Wave Color;0.3349057,0.9565173,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1426.64,894.997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1640.492,204.9196;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0;0.222;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;87;-1694.362,80.6746;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1379.764,689.6462;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;2.34;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-1303.764,584.6462;Inherit;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1386.31,793.2482;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1427.657,280.9095;Inherit;False;Constant;_1;1;3;0;Create;True;0;0;0;False;0;False;0;0.275;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1124.762,569.6461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1105.308,841.2481;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1405.704,80.6746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;46;-951.77,488.1315;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-984.7078,706.4146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1214.857,81.8679;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1216.676,202.418;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1559.565,-82.6702;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;99;-1699.943,-177.8454;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-788.0714,542.7247;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;92;-1047.898,81.4029;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-854.7074,725.4146;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;106;-1293.397,-114.1194;Inherit;False;Constant;_SoftColor;SoftColor;7;0;Create;True;0;0;0;False;0;False;0.4009434,0.7876437,1,0;0.4009434,0.7876437,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;44;-659.0717,540.7247;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;100;-1474.08,-197.8984;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;17;-882.0083,990.8977;Inherit;False;Property;_WaveAmplitude;Wave Amplitude;1;0;Create;True;0;0;0;False;0;False;0;0.73;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;94;-874.8985,82.4029;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;107;-1038.181,-357.6501;Inherit;False;Property;_WaterColor;_WaterColor;4;0;Create;True;0;0;0;False;0;False;0,0.2860703,0.6037736,0;0,0.2860703,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;47;-524.4084,543.9703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-651.1943,672.6027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1015.081,-141.15;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;147;-71.9762,305.7891;Inherit;False;701.8441;409.223;;4;117;112;115;116;Opacity + WaveHeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;95;-697.8982,18.40301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-410.4084,628.9702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-704.625,-349.5292;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-17.9762,540.5385;Inherit;False;Property;_WaveHeight;_WaveHeight;2;0;Create;True;0;0;0;False;0;False;0;2.42703;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-552.9216,-69.92136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-0.8912469,387.9793;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;18;-597.5434,791.5574;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-451.9177,832.0687;Inherit;False;WaveMovement;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-335.0393,-83.52621;Inherit;False;WaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;115;269.1658,363.576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;394.8679,355.7891;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;136;357.4631,152.1805;Inherit;False;1;0;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;384.5698,-115.5647;Inherit;False;138;WaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;351.0335,99.6385;Inherit;False;139;WaveMovement;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;86;591.8515,-159.7198;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;InteractableWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;12;0
WireConnection;15;1;14;0
WireConnection;8;0;7;1
WireConnection;5;0;13;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;11;0;5;0
WireConnection;11;1;15;0
WireConnection;88;0;87;0
WireConnection;88;1;89;0
WireConnection;6;0;9;0
WireConnection;6;1;11;0
WireConnection;90;0;88;0
WireConnection;90;1;91;0
WireConnection;49;0;46;3
WireConnection;92;0;90;0
WireConnection;92;1;93;0
WireConnection;4;0;6;0
WireConnection;44;0;49;0
WireConnection;100;1;99;0
WireConnection;100;2;102;0
WireConnection;94;0;92;0
WireConnection;47;0;44;0
WireConnection;16;0;4;0
WireConnection;16;1;17;0
WireConnection;105;0;100;0
WireConnection;105;1;106;0
WireConnection;95;0;94;0
WireConnection;42;0;16;0
WireConnection;42;1;47;0
WireConnection;96;0;107;0
WireConnection;96;1;105;0
WireConnection;104;0;96;0
WireConnection;104;1;95;0
WireConnection;18;2;42;0
WireConnection;139;0;18;0
WireConnection;138;0;104;0
WireConnection;115;0;112;2
WireConnection;115;1;117;0
WireConnection;116;0;115;0
WireConnection;86;2;140;0
WireConnection;86;9;116;0
WireConnection;86;11;141;0
WireConnection;86;14;136;0
ASEEND*/
//CHKSM=C78F71D2825B2245EACD14BF8D8F6ABAB6948323