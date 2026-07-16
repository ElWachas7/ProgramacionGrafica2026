// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InfiniteScreenShader"
{
	Properties
	{
		_InfiniteShader("InfiniteShader", 2D) = "white" {}
		_RotationSpeed("RotationSpeed", Float) = 0
		_ZoomSpeed("ZoomSpeed", Float) = 0.5
		_ZoomValues("ZoomValues", Vector) = (-1,1,0.2,1.04)
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

		uniform sampler2D _InfiniteShader;
		uniform float _RotationSpeed;
		uniform float _ZoomSpeed;
		uniform float4 _ZoomValues;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime15 = _Time.y * _RotationSpeed;
			float cos9 = cos( mulTime15 );
			float sin9 = sin( mulTime15 );
			float2 rotator9 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos9 , -sin9 , sin9 , cos9 )) + float2( 0.5,0.5 );
			float4 color5 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			o.Albedo = ( ( 1.0 - tex2D( _InfiniteShader, ( ( ( rotator9 - float2( 0.5,0.5 ) ) * (_ZoomValues.z + (sin( ( mulTime15 * _ZoomSpeed ) ) - _ZoomValues.x) * (_ZoomValues.w - _ZoomValues.z) / (_ZoomValues.y - _ZoomValues.x)) ) + float2( 0.5,0.5 ) ) ).a ) * color5 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
753;81;496;909;1359.276;319.4488;1.3;False;False
Node;AmplifyShaderEditor.CommentaryNode;32;-1809.285,-294.1462;Inherit;False;1650.639;787.7225;Comment;19;7;15;24;23;10;9;18;28;27;19;20;22;1;5;6;4;46;47;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1682.691,-15.73525;Inherit;False;Property;_RotationSpeed;RotationSpeed;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1464.103,-5.283208;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;47;-1317.216,108.8492;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1786.585,228.679;Inherit;False;Property;_ZoomSpeed;ZoomSpeed;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;46;-1606.934,149.9122;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1463.59,-161.9363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1589.247,216.579;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;48;-1465.467,365.5238;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;9;-1214.544,-115.1363;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;18;-1211.454,13.70372;Inherit;False;Constant;_CenterZoom;CenterZoom;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector4Node;52;-1547.591,443.0877;Inherit;False;Property;_ZoomValues;ZoomValues;4;0;Create;True;0;0;0;False;0;False;-1,1,0.2,1.04;-1,1,0.2,1.04;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1026.173,-51.55421;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-1320.605,415.7122;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-881.8854,99.56469;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;21;-967.5887,511.5017;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-662.6392,270.4214;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-803.2901,-244.1462;Inherit;True;Property;_InfiniteShader;InfiniteShader;0;0;Create;True;0;0;0;False;0;False;-1;fd817c268fe72de4986386ac318d9943;fd817c268fe72de4986386ac318d9943;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-619.4023,439.3536;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-406.5475,120.2397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-320.6452,358.5763;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1338.332,165.7014;Inherit;True;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-1133.893,146.8765;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-26.87009,6.913954;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InfiniteScreenShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;7;0
WireConnection;47;0;15;0
WireConnection;46;0;47;0
WireConnection;23;0;46;0
WireConnection;23;1;24;0
WireConnection;48;0;23;0
WireConnection;9;0;10;0
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
WireConnection;1;1;22;0
WireConnection;6;0;1;4
WireConnection;4;0;6;0
WireConnection;4;1;5;0
WireConnection;27;0;28;0
WireConnection;0;0;4;0
ASEEND*/
//CHKSM=6CD7E70F11D0C0EE433B11F65A605A5746138750