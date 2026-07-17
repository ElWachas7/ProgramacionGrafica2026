// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InfiniteScreenShader"
{
	Properties
	{
		_RotationSpeed("RotationSpeed", Float) = 0
		_ZoomSpeed("ZoomSpeed", Float) = 0.5
		_ZoomValues("ZoomValues", Vector) = (-1,1,0.2,1.04)
		_WavesAmount("WavesAmount", Float) = 20
		_SinStrengthReducer("SinStrengthReducer", Float) = 0.02
		_SinTimeSpeed("SinTimeSpeed", Float) = 5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
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
		uniform float _WavesAmount;
		uniform float _RotationSpeed;
		uniform float _SinTimeSpeed;
		uniform float _SinStrengthReducer;
		uniform float _ZoomSpeed;
		uniform float4 _ZoomValues;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime15 = _Time.y * _RotationSpeed;
			float4 appendResult71 = (float4(( sin( ( ( i.uv_texcoord.y * _WavesAmount ) + ( mulTime15 * _SinTimeSpeed ) ) ) * _SinStrengthReducer ) , 0.0 , 0.0 , 0.0));
			float cos9 = cos( mulTime15 );
			float sin9 = sin( mulTime15 );
			float2 rotator9 = mul( ( float4( i.uv_texcoord, 0.0 , 0.0 ) + appendResult71 ).xy - float2( 0.5,0.5 ) , float2x2( cos9 , -sin9 , sin9 , cos9 )) + float2( 0.5,0.5 );
			float4 color5 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			o.Albedo = ( ( 1.0 - tex2D( _TextureSample0, ( ( ( rotator9 - float2( 0.5,0.5 ) ) * (_ZoomValues.z + (sin( ( mulTime15 * _ZoomSpeed ) ) - _ZoomValues.x) * (_ZoomValues.w - _ZoomValues.z) / (_ZoomValues.y - _ZoomValues.x)) ) + float2( 0.5,0.5 ) ) ).a ) * color5 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
524;81;1395;911;2368.411;796.891;2.194892;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2185.499,-186.3447;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;87;-1881.61,-719.2962;Inherit;False;1033.197;374.9839;Efecto de olas;10;64;62;66;65;63;67;68;70;69;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2117.948,-14.76417;Inherit;False;Property;_RotationSpeed;RotationSpeed;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1831.61,-460.3123;Inherit;False;Property;_SinTimeSpeed;SinTimeSpeed;5;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;62;-1800.768,-669.2962;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;64;-1829.497,-554.1023;Inherit;False;Property;_WavesAmount;WavesAmount;3;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1872.053,-10.06152;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1639.567,-643.2965;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1577.361,-497.2324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-1456.542,-667.5125;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1419.444,-561.0125;Inherit;False;Property;_SinStrengthReducer;SinStrengthReducer;4;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-1320.041,-668.8129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1170.13,-657.9375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-1009.414,-658.5496;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;88;-1844.073,238.4495;Inherit;False;820.3069;389.6867;Logica de zoom;5;24;23;48;52;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;74;-856.9019,-396.7816;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1794.073,308.0363;Inherit;False;Property;_ZoomSpeed;ZoomSpeed;1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-1571.7,-185.9362;Inherit;False;823.0672;340.9639;Logica de rotacion en base al centro;4;19;9;18;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;73;-1535.33,-366.5973;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1523.197,-132.8796;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1593.739,288.4495;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;48;-1419.05,305.6315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;9;-1329.744,-135.9362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;18;-1211.454,13.70372;Inherit;False;Constant;_CenterZoom;CenterZoom;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector4Node;52;-1550.586,416.1362;Inherit;False;Property;_ZoomValues;ZoomValues;2;0;Create;True;0;0;0;False;0;False;-1,1,0.2,1.04;-1,1,0.2,1.04;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1026.173,-51.55421;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-1230.766,315.3926;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-957.2221,281.9623;Inherit;False;Constant;_Recenter;Recenter;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-910.6329,103.8767;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-751.0548,163.9845;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;86;-614.6391,103.9896;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-499.8887,448.6995;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-306.8591,287.5126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-199.4182,398.7461;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3.953756,497.6268;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InfiniteScreenShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;0;10;0
WireConnection;15;0;7;0
WireConnection;63;0;62;1
WireConnection;63;1;64;0
WireConnection;65;0;15;0
WireConnection;65;1;66;0
WireConnection;67;0;63;0
WireConnection;67;1;65;0
WireConnection;68;0;67;0
WireConnection;69;0;68;0
WireConnection;69;1;70;0
WireConnection;71;0;69;0
WireConnection;74;0;71;0
WireConnection;73;0;74;0
WireConnection;72;0;10;0
WireConnection;72;1;73;0
WireConnection;23;0;15;0
WireConnection;23;1;24;0
WireConnection;48;0;23;0
WireConnection;9;0;72;0
WireConnection;9;2;15;0
WireConnection;19;0;9;0
WireConnection;19;1;18;0
WireConnection;50;0;48;0
WireConnection;50;1;52;1
WireConnection;50;2;52;2
WireConnection;50;3;52;3
WireConnection;50;4;52;4
WireConnection;20;0;19;0
WireConnection;20;1;50;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;86;1;22;0
WireConnection;6;0;86;4
WireConnection;4;0;6;0
WireConnection;4;1;5;0
WireConnection;0;0;4;0
ASEEND*/
//CHKSM=2BDDBCE14701950BE52D11A591C91C8FB66C2E32