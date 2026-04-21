// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tomas_Perez_HighQualityOcean"
{
	Properties
	{
		_Smoothnes("Smoothnes", Range( 0 , 1)) = 0.5411765
		_NormalPower("NormalPower", Range( 0 , 1)) = 1
		_WaveHeight("Wave Height", Range( 0 , 1)) = 0
		_Normals_3D("Normals_3D", 3D) = "white" {}
		_TextureSample0("Texture Sample 0", 3D) = "white" {}
		_Tiling("Tiling", Float) = 0
		_WaveSpeed("WaveSpeed", Float) = 0
		_MaxStrenght("MaxStrenght", Range( 0 , 1)) = 0.6470588
		_WaveMask("WaveMask", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE3D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE3D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE3D(tex,samplerTex,coord) tex3D(tex,coord)
		#define SAMPLE_TEXTURE3D_LOD(tex,samplerTex,coord,lod) tex3Dlod(tex,float4(coord,lod))
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		UNITY_DECLARE_TEX3D_NOSAMPLER(_TextureSample0);
		uniform float _Tiling;
		uniform float _WaveSpeed;
		SamplerState sampler_TextureSample0;
		uniform float _WaveHeight;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_WaveMask);
		SamplerState sampler_WaveMask;
		uniform float _MaxStrenght;
		UNITY_DECLARE_TEX3D_NOSAMPLER(_Normals_3D);
		SamplerState sampler_Normals_3D;
		uniform float _NormalPower;
		uniform float _Smoothnes;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 64.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime25 = _Time.y * _WaveSpeed;
			float4 appendResult23 = (float4(( ase_worldPos.x * _Tiling ) , ( ase_worldPos.z * _Tiling ) , mulTime25 , 0.0));
			float4 _3duvs26 = appendResult23;
			float4 tex3DNode36 = SAMPLE_TEXTURE3D_LOD( _TextureSample0, sampler_TextureSample0, _3duvs26.xyz, 0.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult45 = (float4(ase_vertex3Pos.x , ase_vertex3Pos.z , 0.0 , 0.0));
			float _Smoother54 = saturate( ( SAMPLE_TEXTURE2D_LOD( _WaveMask, sampler_WaveMask, (appendResult45*0.0 + 0.0).xy, 0.0 ).r + (0.0 + (_MaxStrenght - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) );
			float4 VertexOffset42 = ( tex3DNode36 * float4( ( ( float3(0,1,0) * (0.0 + (_WaveHeight - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) * _Smoother54 ) , 0.0 ) );
			v.vertex.xyz += VertexOffset42.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float mulTime25 = _Time.y * _WaveSpeed;
			float4 appendResult23 = (float4(( ase_worldPos.x * _Tiling ) , ( ase_worldPos.z * _Tiling ) , mulTime25 , 0.0));
			float4 _3duvs26 = appendResult23;
			float3 Normals31 = UnpackScaleNormal( SAMPLE_TEXTURE3D( _Normals_3D, sampler_Normals_3D, _3duvs26.xyz ), _NormalPower );
			o.Normal = Normals31;
			float4 color58 = IsGammaSpace() ? float4(0,0.4755421,0.745283,1) : float4(0,0.1920975,0.5152035,1);
			float4 tex3DNode36 = SAMPLE_TEXTURE3D( _TextureSample0, sampler_TextureSample0, _3duvs26.xyz );
			float4 _displace37 = tex3DNode36;
			float4 lerpResult61 = lerp( color58 , ( color58 + 0.1 ) , _displace37);
			float4 Albedo64 = lerpResult61;
			o.Albedo = Albedo64.rgb;
			o.Smoothness = _Smoothnes;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
213;73;1222;680;-452.495;626.3201;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;66;-1722.692,245.9387;Inherit;False;1601.094;575.6049;SmootherWaves;11;44;48;47;45;46;53;50;49;52;57;54;SmootherWaves;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-2744.25,-1149.473;Inherit;False;1018.78;577.0927;3D UVs;9;19;20;25;23;24;27;26;29;30;3D UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;44;-1672.692,295.9387;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1485.944,621.5436;Inherit;False;Constant;_ProjectionOffset;ProjectionOffset;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1458.944,335.5436;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1483.944,517.5436;Inherit;False;Constant;_ProjectionScale;ProjectionScale;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2416.188,-688.5359;Inherit;False;Property;_WaveSpeed;WaveSpeed;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2663.263,-852.2214;Inherit;False;Property;_Tiling;Tiling;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-2694.25,-1098.843;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;30;-2359.409,-931.1855;Inherit;False;120;124;V;1;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2358.62,-1074.473;Inherit;False;120;124;U;1;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-2225.72,-683.7514;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2355.62,-1040.473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2356.622,-897.0658;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1235.944,637.5436;Inherit;False;Property;_MaxStrenght;MaxStrenght;8;0;Create;True;0;0;0;False;0;False;0.6470588;0.6470588;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-978.9233,382.4007;Inherit;False;277.6733;220.5714;DefaultValue;1;51;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;46;-1210.944,446.5436;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-2117.852,-1019.48;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;49;-915.9443,614.5436;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-973.4948,418.6049;Inherit;True;Property;_WaveMask;WaveMask;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-618.466,468.7277;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;11;-1141.446,-751.3665;Inherit;False;1514.978;733.6942;Displace;11;39;37;10;35;36;38;40;41;42;56;55;Displace;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1949.47,-1023.381;Inherit;False;_3duvs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1067.155,-210.1018;Inherit;False;Property;_WaveHeight;Wave Height;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;57;-494.1843,470.1551;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1115.891,-661.759;Inherit;False;26;_3duvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;65;-2652.003,-277.9124;Inherit;False;944.0879;379.8655;Albedo;6;59;60;62;58;61;64;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;40;-726.1608,-378.9326;Inherit;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;38;-749.1608,-203.9326;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-345.5988,461.9036;Inherit;False;_Smoother;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-915.5389,-686.9424;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;c64e20d5eb27fc44dbb45cf8678fa597;5e25639a3edb160418119d84666ed03a;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-493.1608,-278.9326;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-288.9502,-101.1747;Inherit;False;54;_Smoother;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-583.1799,-1239.765;Inherit;False;793.8466;281.0519;Normals;3;16;17;31;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1186.446,-1184.366;Inherit;False;578.6055;362.3045;NormalPower;3;15;14;13;NormalPower;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;58;-2602.003,-227.9124;Inherit;False;Constant;_SeaColor;Sea Color;9;0;Create;True;0;0;0;False;0;False;0,0.4755421,0.745283,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-546.5389,-511.9424;Inherit;False;_displace;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2557.063,-64.392;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-2313.063,-147.392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2312.916,-14.04684;Inherit;False;37;_displace;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1177.555,-1139.417;Inherit;False;Property;_NormalPower;NormalPower;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-196.62,-420.9475;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-533.1799,-1151.756;Inherit;False;26;_3duvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;61;-2130.063,-215.392;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;16;-332.2408,-1188.713;Inherit;True;Property;_Normals_3D;Normals_3D;4;0;Create;True;0;0;0;False;0;False;-1;8412d1f8d5b7c084081a79e0303b88f5;None;True;0;False;white;LockedToTexture3D;True;Object;-1;Auto;Texture3D;8;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-86.32568,-682.5502;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1931.916,-226.0469;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;90.09723,-686.4507;Inherit;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-13.33327,-1189.765;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;695.1687,-484.8948;Inherit;False;42;VertexOffset;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2524.785,-1833.433;Inherit;False;31;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1982.47,-688.3806;Inherit;False;_Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;14;-1161.555,-1042.417;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.EdgeLengthTessNode;79;806.495,-253.3201;Inherit;False;1;0;FLOAT;64;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1;681.5534,-601.527;Inherit;False;Property;_Smoothnes;Smoothnes;1;0;Create;True;0;0;0;False;0;False;0.5411765;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;782.9896,-768.323;Inherit;False;64;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;15;-847.5885,-1044.849;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;711.9631,-684.4888;Inherit;False;31;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;78;1061.358,-643.8568;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Tomas_Perez_HighQualityOcean;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;44;1
WireConnection;45;1;44;3
WireConnection;25;0;24;0
WireConnection;21;0;19;1
WireConnection;21;1;20;0
WireConnection;22;0;19;3
WireConnection;22;1;20;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;46;2;48;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;23;2;25;0
WireConnection;49;0;50;0
WireConnection;51;1;46;0
WireConnection;52;0;51;1
WireConnection;52;1;49;0
WireConnection;26;0;23;0
WireConnection;57;0;52;0
WireConnection;38;0;10;0
WireConnection;54;0;57;0
WireConnection;36;1;35;0
WireConnection;39;0;40;0
WireConnection;39;1;38;0
WireConnection;37;0;36;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;56;0;39;0
WireConnection;56;1;55;0
WireConnection;61;0;58;0
WireConnection;61;1;59;0
WireConnection;61;2;62;0
WireConnection;16;1;17;0
WireConnection;16;5;13;0
WireConnection;41;0;36;0
WireConnection;41;1;56;0
WireConnection;64;0;61;0
WireConnection;42;0;41;0
WireConnection;31;0;16;0
WireConnection;27;0;25;0
WireConnection;15;1;13;0
WireConnection;15;2;14;2
WireConnection;78;0;68;0
WireConnection;78;1;34;0
WireConnection;78;4;1;0
WireConnection;78;11;43;0
WireConnection;78;14;79;0
ASEEND*/
//CHKSM=DD31DE5DFF10539C4E81DB47D45ED39713E133D8