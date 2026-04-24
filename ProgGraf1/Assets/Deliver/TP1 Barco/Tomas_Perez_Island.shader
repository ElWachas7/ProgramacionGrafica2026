// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tomas_Perez_Island"
{
	Properties
	{
		_IslandTile("IslandTile", Float) = 10
		_IslandHeight("IslandHeight", Range( 40 , 50)) = 40
		_StoneHeight("StoneHeight", Range( 0 , 8)) = 3
		_SAND_ALBEDO("SAND_ALBEDO", 2D) = "white" {}
		_STONE_ALBEDO("STONE_ALBEDO", 2D) = "white" {}
		_HEIGHTMAP("HEIGHTMAP", 2D) = "white" {}
		_STONE_Normal("STONE_Normal", 2D) = "white" {}
		_SAND_Normal("SAND_Normal", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _HEIGHTMAP;
		uniform float4 _HEIGHTMAP_ST;
		uniform float _IslandHeight;
		uniform sampler2D _SAND_Normal;
		uniform float _IslandTile;
		uniform sampler2D _STONE_Normal;
		uniform float _StoneHeight;
		uniform sampler2D _SAND_ALBEDO;
		uniform sampler2D _STONE_ALBEDO;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_HEIGHTMAP = v.texcoord * _HEIGHTMAP_ST.xy + _HEIGHTMAP_ST.zw;
			float4 HeightMap33 = ( ( 1.0 - tex2Dlod( _HEIGHTMAP, float4( uv_HEIGHTMAP, 0, 0.0) ) ) * float4( float3(0,1,0) , 0.0 ) * _IslandHeight );
			v.vertex.xyz += HeightMap33.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult13 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float2 WorldTileUV32 = ( ( appendResult13 * float4( float2( 1,1 ), 0.0 , 0.0 ) ) * _IslandTile );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float StepDiference56 = step( ase_vertex3Pos.y , _StoneHeight );
			float lerpResult67 = lerp( saturate( (WorldNormalVector( i , tex2D( _SAND_Normal, WorldTileUV32 ).rgb )).y ) , saturate( (WorldNormalVector( i , tex2D( _STONE_Normal, WorldTileUV32 ).rgb )).y ) , StepDiference56);
			float4 Normal63 = saturate( lerpResult67 );
			o.Normal = Normal63.rgb;
			float4 lerpResult55 = lerp( tex2D( _SAND_ALBEDO, WorldTileUV32 ) , tex2D( _STONE_ALBEDO, WorldTileUV32 ) , StepDiference56);
			float4 Albedo39 = saturate( lerpResult55 );
			o.Albedo = Albedo39.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
127;73;1655;703;7882.345;1574.343;7.010776;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-3723.816,-1200.094;Inherit;False;1144.221;454.6425;WorldUV;7;17;15;6;19;18;32;13;WorldUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-3675.414,-1147.061;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;13;-3422.566,-1112.786;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;15;-3357.391,-897.2335;Inherit;False;Constant;_TileStretch;TileStretch;2;0;Create;True;0;0;0;False;0;False;1,1;1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;17;-3118.699,-937.3278;Inherit;False;Property;_IslandTile;IslandTile;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3130.635,-1047.993;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2953.069,-1044.684;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;61;-3746.176,361.552;Inherit;False;1502.411;573.5173;Normal;13;70;63;62;67;85;81;69;65;66;82;72;80;79;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-3734.954,-672.5118;Inherit;False;672.5657;332.1141;Step;4;43;45;44;56;Step;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-2804.629,-1051.739;Inherit;False;WorldTileUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;43;-3718.954,-629.5118;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;59;-3740.777,980.1115;Inherit;False;1055.161;519.0945;HeightMap;8;33;22;25;24;31;1;104;53;HeightMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-3708.5,608.0013;Inherit;False;32;WorldTileUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-3722.766,722.0724;Inherit;True;Property;_STONE_Normal;STONE_Normal;7;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;45;-3723.825,-427.3973;Inherit;False;Property;_StoneHeight;StoneHeight;3;0;Create;True;0;0;0;False;0;False;3;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;79;-3717.231,419.1707;Inherit;True;Property;_SAND_Normal;SAND_Normal;8;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;60;-3740.899,-264.892;Inherit;False;1375.113;582.4811;Albedo;9;50;51;35;3;4;55;57;54;39;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;44;-3433.624,-558.3386;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-3712.349,1033.253;Inherit;False;220;230;Texture = Shadow;1;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;69;-3479.289,722.2237;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;-3471.691,419.6212;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;51;-3706.899,84.58906;Inherit;True;Property;_STONE_ALBEDO;STONE_ALBEDO;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-3285.133,-555.366;Inherit;False;StepDiference;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-3668.779,-17.0405;Inherit;False;32;WorldTileUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;72;-3198.08,424.2429;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;52;-3701.349,1075.253;Inherit;True;Property;_HEIGHTMAP;HEIGHTMAP;6;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldNormalVector;81;-3206.403,727.8547;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;50;-3701.135,-214.892;Inherit;True;Property;_SAND_ALBEDO;SAND_ALBEDO;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-3479.638,1075.623;Inherit;True;Property;_HeightMap;HeightMap;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;85;-3032.92,777.0751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2990.943,608.7687;Inherit;False;56;StepDiference;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-3349.76,-159.7557;Inherit;True;Property;_Sand;Sand;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;82;-3001.536,478.6844;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3353.221,56.24033;Inherit;True;Property;_Stone;Stone;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3054.62,137.8359;Inherit;False;56;StepDiference;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-2737.618,554.761;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;31;-3202.92,1080.286;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;55;-2900.071,-57.00001;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;24;-3346.258,1259.831;Inherit;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;25;-3461.311,1405.441;Inherit;False;Property;_IslandHeight;IslandHeight;2;0;Create;True;0;0;0;False;0;False;40;0;40;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-2581.991,560.291;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2984.885,1242.777;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;54;-2747.445,-46.46992;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-2596.786,-61.36884;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2864.15,1238.62;Inherit;False;HeightMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2429.333,556.3922;Inherit;False;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-2066.142,26.47327;Inherit;False;39;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-2079.855,104.2732;Inherit;False;63;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;30;-2094.679,377.8124;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-2075.499,300.4442;Inherit;False;33;HeightMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1827.246,24.24918;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Tomas_Perez_Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;104;-3137.311,1325.441;Inherit;False;100;100;Clamp;0;;1,1,1,1;0;0
WireConnection;13;0;6;1
WireConnection;13;1;6;3
WireConnection;18;0;13;0
WireConnection;18;1;15;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;32;0;19;0
WireConnection;44;0;43;2
WireConnection;44;1;45;0
WireConnection;69;0;65;0
WireConnection;69;1;66;0
WireConnection;80;0;79;0
WireConnection;80;1;66;0
WireConnection;56;0;44;0
WireConnection;72;0;80;0
WireConnection;81;0;69;0
WireConnection;1;0;52;0
WireConnection;85;0;81;2
WireConnection;3;0;50;0
WireConnection;3;1;35;0
WireConnection;82;0;72;2
WireConnection;4;0;51;0
WireConnection;4;1;35;0
WireConnection;67;0;82;0
WireConnection;67;1;85;0
WireConnection;67;2;70;0
WireConnection;31;0;1;0
WireConnection;55;0;3;0
WireConnection;55;1;4;0
WireConnection;55;2;57;0
WireConnection;62;0;67;0
WireConnection;22;0;31;0
WireConnection;22;1;24;0
WireConnection;22;2;25;0
WireConnection;54;0;55;0
WireConnection;39;0;54;0
WireConnection;33;0;22;0
WireConnection;63;0;62;0
WireConnection;0;0;48;0
WireConnection;0;1;71;0
WireConnection;0;11;34;0
WireConnection;0;14;30;0
ASEEND*/
//CHKSM=B71840ED7B62DD4B5EA2CED58C85F40B39A4A586