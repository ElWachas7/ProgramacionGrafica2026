// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Maia_Mojsiejczuk_BuildingParalaxxMapping"
{
	Properties
	{
		_Brick_HeightTexture("Brick_HeightTexture", 2D) = "white" {}
		_Scale("Scale", Range( -0.01 , 0)) = -0.01
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Texture0;
		uniform sampler2D _Brick_HeightTexture;
		uniform float4 _Brick_HeightTexture_ST;
		uniform float _Scale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Vector0 = float4(5,5,1,1);
			float4 appendResult5 = (float4(_Vector0.x , _Vector0.y , 0.0 , 0.0));
			float4 appendResult6 = (float4(_Vector0.z , _Vector0.w , 0.0 , 0.0));
			float2 Offset9 = (i.uv_texcoord*appendResult5.xy + appendResult6.xy);
			o.Normal = tex2D( _Texture0, Offset9 ).rgb;
			float4 color42 = IsGammaSpace() ? float4(0.4528302,0.2114632,0.2114632,0) : float4(0.1729492,0.03678946,0.03678946,0);
			float2 uv_Brick_HeightTexture = i.uv_texcoord * _Brick_HeightTexture_ST.xy + _Brick_HeightTexture_ST.zw;
			float RegisteredScale51 = _Scale;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 RegisteredViewDir15 = ase_worldViewDir;
			float2 Offset11 = ( ( tex2D( _Brick_HeightTexture, uv_Brick_HeightTexture ).r - 1 ) * RegisteredViewDir15.xy * RegisteredScale51 ) + Offset9;
			float2 Offset17 = ( ( tex2D( _Brick_HeightTexture, Offset11 ).r - 1 ) * RegisteredViewDir15.xy * RegisteredScale51 ) + Offset11;
			float2 Offset27 = ( ( tex2D( _Brick_HeightTexture, Offset17 ).r - 1 ) * RegisteredViewDir15.xy * RegisteredScale51 ) + Offset17;
			float2 Offset33 = ( ( tex2D( _Brick_HeightTexture, Offset27 ).r - 1 ) * RegisteredViewDir15.xy * RegisteredScale51 ) + Offset27;
			float2 Offset39 = ( ( tex2D( _Brick_HeightTexture, Offset33 ).r - 1 ) * RegisteredViewDir15.xy * RegisteredScale51 ) + Offset33;
			o.Albedo = ( color42 * tex2D( _Brick_HeightTexture, Offset39 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
220;73;1244;554;5229.353;1848.976;2.596283;True;False
Node;AmplifyShaderEditor.CommentaryNode;58;-4620.119,-1946.365;Inherit;False;634.7871;379;forzas el tiling, por eso se deja el input Tex vacío en "Texture Coordinates";4;8;6;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;4;-4570.119,-1874.262;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;5,5,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-4391.999,-1896.365;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-4390.999,-1750.365;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-4343.824,-2100.236;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-4095.741,-1557.774;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;-0.01;0;-0.01;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;14;-3877.354,-1437.442;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;8;-4202.332,-1876.873;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-3688.905,-1435.755;Inherit;False;RegisteredViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-3928.355,-1756.391;Inherit;True;Property;_Brick_HeightTexture;Brick_HeightTexture;0;0;Create;True;0;0;0;False;0;False;-1;003e22cdb2ce86641b1928ffe144567e;003e22cdb2ce86641b1928ffe144567e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-3815.834,-1558.134;Inherit;False;RegisteredScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-3836.332,-1892.873;Inherit;False;Offset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;11;-3535.333,-1824.873;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-3342.533,-1503.041;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-3152.696,-1144.077;Inherit;False;15;RegisteredViewDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-3149.618,-1266.422;Inherit;False;51;RegisteredScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;17;-2862.603,-1430.982;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2591.398,-990.2859;Inherit;False;51;RegisteredScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-2817.064,-1193.409;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2536.323,-913.9137;Inherit;False;15;RegisteredViewDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ParallaxMappingNode;27;-2287.309,-1103.254;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1949.349,-657.0048;Inherit;False;51;RegisteredScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2022.5,-565.2941;Inherit;False;15;RegisteredViewDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-2247.672,-855.184;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;33;-1717.917,-765.0292;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1423.745,-315.2542;Inherit;False;51;RegisteredScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1425.424,-228.382;Inherit;False;15;RegisteredViewDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;40;-1694.894,-522.9453;Inherit;True;Property;_TextureSample6;Texture Sample 6;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;39;-1167.496,-435.1471;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;45;-1055.748,-112.9619;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;ce0c4ff6339b0ee449c8bbff55262863;ce0c4ff6339b0ee449c8bbff55262863;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;41;-941.7528,-357.297;Inherit;True;Property;_TextureSample7;Texture Sample 7;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;46;-991.2952,106.5841;Inherit;False;9;Offset;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;42;-808.0909,-566.1441;Inherit;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.4528302,0.2114632,0.2114632,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-539.0958,-397.3956;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-791.5756,-137.2018;Inherit;True;Property;_BrickNormal_Type01;BrickNormal_Type01;5;0;Create;True;0;0;0;False;0;False;-1;ce0c4ff6339b0ee449c8bbff55262863;ce0c4ff6339b0ee449c8bbff55262863;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-319.806,-488.9661;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Maia_Mojsiejczuk_BuildingParalaxxMapping;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;1
WireConnection;5;1;4;2
WireConnection;6;0;4;3
WireConnection;6;1;4;4
WireConnection;8;0;7;0
WireConnection;8;1;5;0
WireConnection;8;2;6;0
WireConnection;15;0;14;0
WireConnection;51;0;12;0
WireConnection;9;0;8;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;11;2;51;0
WireConnection;11;3;15;0
WireConnection;16;1;11;0
WireConnection;17;0;11;0
WireConnection;17;1;16;0
WireConnection;17;2;53;0
WireConnection;17;3;54;0
WireConnection;28;1;17;0
WireConnection;27;0;17;0
WireConnection;27;1;28;0
WireConnection;27;2;49;0
WireConnection;27;3;55;0
WireConnection;34;1;27;0
WireConnection;33;0;27;0
WireConnection;33;1;34;0
WireConnection;33;2;47;0
WireConnection;33;3;56;0
WireConnection;40;1;33;0
WireConnection;39;0;33;0
WireConnection;39;1;40;0
WireConnection;39;2;48;0
WireConnection;39;3;57;0
WireConnection;41;1;39;0
WireConnection;43;0;42;0
WireConnection;43;1;41;0
WireConnection;44;0;45;0
WireConnection;44;1;46;0
WireConnection;0;0;43;0
WireConnection;0;1;44;0
ASEEND*/
//CHKSM=1AD7815D2ADED5554841804DA591B72E1EC97043