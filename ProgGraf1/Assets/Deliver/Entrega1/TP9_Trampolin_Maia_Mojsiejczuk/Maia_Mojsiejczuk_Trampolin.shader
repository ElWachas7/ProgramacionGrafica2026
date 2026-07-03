// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Maia_Mojsiejczuk_Trampolin"
{
	Properties
	{
		_PlatformTexture("PlatformTexture", 2D) = "white" {}
		_Platformcolor("Platform color", Color) = (0.7830189,0.136659,0.136659,0)
		_ArrowPattern("ArrowPattern", 2D) = "white" {}
		_ArrowsColor("ArrowsColor", Color) = (0.8490566,0.7825121,0.2122642,0)
		_LinearSpeed("LinearSpeed", Range( 0.4 , 2)) = 1
		_Frequency("Frequency", Range( 0 , 2)) = 1
		_Platform_XYZ("Platform_XYZ", Vector) = (0,1,0,0)
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _LinearSpeed;
		uniform float _Frequency;
		uniform float3 _Platform_XYZ;
		uniform sampler2D _PlatformTexture;
		uniform float4 _PlatformTexture_ST;
		uniform float4 _Platformcolor;
		uniform float4 _ArrowsColor;
		uniform sampler2D _ArrowPattern;
		uniform float4 _ArrowPattern_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime26 = _Time.y * _LinearSpeed;
			float temp_output_33_0 = ( 1.0 * sin( ( mulTime26 * ( _Frequency * 6.28318548202515 ) ) ) );
			v.vertex.xyz += ( temp_output_33_0 * _Platform_XYZ );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_PlatformTexture = i.uv_texcoord * _PlatformTexture_ST.xy + _PlatformTexture_ST.zw;
			float mulTime26 = _Time.y * _LinearSpeed;
			float temp_output_33_0 = ( 1.0 * sin( ( mulTime26 * ( _Frequency * 6.28318548202515 ) ) ) );
			float2 uv_ArrowPattern = i.uv_texcoord * _ArrowPattern_ST.xy + _ArrowPattern_ST.zw;
			float4 lerpResult18 = lerp( ( tex2D( _PlatformTexture, uv_PlatformTexture ) * _Platformcolor ) , ( _ArrowsColor * temp_output_33_0 ) , ( 1.0 - tex2D( _ArrowPattern, uv_ArrowPattern ) ));
			o.Albedo = lerpResult18.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
158;180;1245;511;2063.006;-491.0861;1.159672;True;False
Node;AmplifyShaderEditor.RangedFloatNode;27;-1518.128,852.7153;Inherit;False;Property;_Frequency;Frequency;6;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1609.56,672.2811;Inherit;False;Property;_LinearSpeed;LinearSpeed;5;0;Create;True;0;0;0;False;0;False;1;0;0.4;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;28;-1305.678,951.4487;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-1323.836,679.0804;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1161.55,858.3898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1127.226,700.0011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-1178.443,155.926;Inherit;True;Property;_ArrowPattern;ArrowPattern;2;0;Create;True;0;0;0;False;0;False;4f9e5716c27f1f14984c6b23cdf070e6;4f9e5716c27f1f14984c6b23cdf070e6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;32;-986.5012,595.5935;Inherit;False;Constant;_NormalMult;NormalMult;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-873.246,-359.7345;Inherit;False;528.3676;449.9298;platformColor;3;15;17;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;31;-980.828,700.0013;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-937.0243,155.9261;Inherit;True;Property;_Flechas_Negras;Flechas_Negras;2;0;Create;True;0;0;0;False;0;False;-1;4f9e5716c27f1f14984c6b23cdf070e6;4f9e5716c27f1f14984c6b23cdf070e6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-792.8784,-121.8048;Inherit;False;Property;_Platformcolor;Platform color;1;0;Create;True;0;0;0;False;0;False;0.7830189,0.136659,0.136659,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-880.5576,389.2954;Inherit;False;Property;_ArrowsColor;ArrowsColor;4;0;Create;True;0;0;0;False;0;False;0.8490566,0.7825121,0.2122642,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-719.8073,643.2581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-823.246,-309.7345;Inherit;True;Property;_PlatformTexture;PlatformTexture;0;0;Create;True;0;0;0;False;0;False;-1;2f247da77fd06664b918d6df66f760a6;2f247da77fd06664b918d6df66f760a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-520.3999,373.8418;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;36;-628.2062,198.2513;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;35;-640.3663,753.3404;Inherit;False;Property;_Platform_XYZ;Platform_XYZ;7;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-506.8784,-125.8048;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-294.7354,47.3384;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-481.485,643.258;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3471.328,1147.238;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;37;-3673.307,1166.238;Inherit;False;Property;_Floor_TextureTilling;Floor_TextureTilling;3;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Maia_Mojsiejczuk_Trampolin;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;24;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;30;0;26;0
WireConnection;30;1;29;0
WireConnection;31;0;30;0
WireConnection;21;0;22;0
WireConnection;33;0;32;0
WireConnection;33;1;31;0
WireConnection;19;0;23;0
WireConnection;19;1;33;0
WireConnection;36;0;21;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;18;2;36;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;38;0;37;0
WireConnection;0;0;18;0
WireConnection;0;11;34;0
ASEEND*/
//CHKSM=2D284DAF7FB72AF1F0BB6BBE9370ED756A3896AD