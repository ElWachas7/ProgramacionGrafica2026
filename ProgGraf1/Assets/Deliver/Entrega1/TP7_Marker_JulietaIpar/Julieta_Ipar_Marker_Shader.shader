// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Marker_Shader"
{
	Properties
	{
		_PowerValue("PowerValue", Float) = 0
		_MarkerColor("MarkerColor", Color) = (1,0.8596004,0.2216981,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform float4 _MarkerColor;
		uniform float _PowerValue;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _MarkerColor.rgb;
			float clampResult45 = clamp( _PowerValue , 0.0 , 1.0 );
			float smoothstepResult38 = smoothstep( clampResult45 , 0.0 , i.uv_texcoord.y);
			float3 ase_worldNormal = i.worldNormal;
			o.Alpha = ( smoothstepResult38 * ( 1.0 - abs( ase_worldNormal.y ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
415;73;795;918;827.4556;601.2055;1.680798;False;False
Node;AmplifyShaderEditor.CommentaryNode;50;-796.1967,-263.8983;Inherit;False;701.2031;474.029;Crea un degradado en la coordenada Y (V), con un valor (clampeado) manejable desde el inspector;7;38;45;40;35;39;47;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-607.1542,239.8259;Inherit;False;754.6446;326.1268;Quitar la iluminación en cara superior e inferior;3;41;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-766.1895,17.10861;Inherit;False;Constant;_MaxClamp;MaxClamp;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-766.4895,-56.14878;Inherit;False;Constant;_MinClamp;MinClamp;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-769.6191,-146.624;Inherit;False;Property;_PowerValue;PowerValue;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-424.0124,428.1462;Inherit;False;333.6447;124.8364;Vuelve positivo la cara inferior (-1) normal;1;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;41;-585.8083,286.2441;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;52;-197.2295,255.6989;Inherit;False;287.366;156;Da vuelta, vuelve invisible las "tapas";1;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-544.5351,-213.8984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;42;-311.7572,476.3636;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;45;-502.2906,-78.509;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-530.0847,84.94975;Inherit;False;Constant;_Max;Max;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-314.1977,-3.212234;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-118.3273,320.4055;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-35.98354,-269.2434;Inherit;False;Property;_MarkerColor;MarkerColor;1;0;Create;True;0;0;0;False;0;False;1,0.8596004,0.2216981,0;1,0.8596004,0.2216981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;10.96965,105.3541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;186.4878,-9.568667;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Marker_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;41;2
WireConnection;45;0;39;0
WireConnection;45;1;47;0
WireConnection;45;2;48;0
WireConnection;38;0;35;2
WireConnection;38;1;45;0
WireConnection;38;2;40;0
WireConnection;43;0;42;0
WireConnection;44;0;38;0
WireConnection;44;1;43;0
WireConnection;0;2;1;0
WireConnection;0;9;44;0
ASEEND*/
//CHKSM=F8B4C285F32B5FFA2EB3111446C89D46A96D864F