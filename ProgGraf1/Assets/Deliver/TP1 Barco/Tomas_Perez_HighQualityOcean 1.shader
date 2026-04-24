// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tomas_Perez_HighQualityOcean 1"
{
	Properties
	{
		_WaveTile("WaveTile", Range( 0 , 0.05)) = 0.05
		_WaveCount("WaveCount", Range( -1 , 0.8)) = 0
		_WaveIntensity("WaveIntensity", Range( -1 , 0.8)) = 0
		_NormalPower("NormalPower", Range( 0 , 1)) = 1
		_WaveHeight("WaveHeight", Range( 0 , 8)) = 4
		_Normals_3D("Normals_3D", 3D) = "white" {}
		_WaveStretch("WaveStretch", Vector) = (1,0.1,0,0)
		_Smoothnes("Smoothnes", Range( 0 , 1)) = 0
		_waterColor("water Color", Color) = (0,0.1464853,0.5372549,1)
		_Tiling("Tiling", Range( 0 , 0.1)) = 0.1
		_TopColor("TopColor", Color) = (0.4089979,0.7206899,0.8584906,1)
		_NormalSpeedArray("NormalSpeedArray", Range( 0 , 1)) = 0.4
		_Distance("Distance", Range( 0 , 10)) = 0
		_DepthMultiply("DepthMultiply", Range( 0 , 0.5)) = 0
		_DepthPower("DepthPower", Range( 0 , 2)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_DepthFoamTileWave("DepthFoamTileWave", Range( 0 , 4)) = 1
		_DepthMaskIntensity("DepthMaskIntensity", Range( -1 , 0.5)) = 0
		_DeapthFoamTileEdge("DeapthFoamTileEdge", Range( 0 , 2)) = 2
		_Refractamount("Refract amount", Range( 0 , 1)) = 0
		_RefractionDepth("Refraction Depth", Range( 0 , 40)) = 10
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform float _Tiling;
		uniform float _NormalSpeedArray;
		uniform float2 _WaveStretch;
		uniform float _WaveTile;
		uniform float _WaveCount;
		uniform float _WaveIntensity;
		uniform float _WaveHeight;
		uniform sampler3D _Normals_3D;
		uniform float _NormalPower;
		uniform float4 _waterColor;
		uniform float4 _TopColor;
		uniform sampler2D _Texture0;
		uniform float _DepthFoamTileWave;
		uniform float _DepthMaskIntensity;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Refractamount;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _RefractionDepth;
		uniform float _Distance;
		uniform float _DeapthFoamTileEdge;
		uniform float _DepthMultiply;
		uniform float _DepthPower;
		uniform float _Smoothnes;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_7_0 = ( _Time.y * 0.2 );
			float2 _Vector0 = float2(1,0.1);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime187 = _Time.y * _NormalSpeedArray;
			float4 appendResult11 = (float4(( ase_worldPos.x * _Tiling ) , ( ase_worldPos.z * _Tiling ) , mulTime187 , 0.0));
			float4 WorldSpaceTile12 = appendResult11;
			float4 WaveTileUV27 = ( ( WorldSpaceTile12 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner3 = ( temp_output_7_0 * _Vector0 + WaveTileUV27.xy);
			float simplePerlin2D2 = snoise( panner3 );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float2 panner29 = ( temp_output_7_0 * _Vector0 + ( WaveTileUV27 * float4( float2( 0.53,0.2 ), 0.0 , 0.0 ) ).xy);
			float simplePerlin2D30 = snoise( panner29 );
			simplePerlin2D30 = simplePerlin2D30*0.5 + 0.5;
			float WavePattern37 = ( ( simplePerlin2D2 + _WaveCount ) + ( simplePerlin2D30 + _WaveIntensity ) );
			float3 WaveHeight39 = ( WavePattern37 * ( _WaveHeight * float3(0,1,0) ) );
			v.vertex.xyz += WaveHeight39;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float mulTime187 = _Time.y * _NormalSpeedArray;
			float4 appendResult11 = (float4(( ase_worldPos.x * _Tiling ) , ( ase_worldPos.z * _Tiling ) , mulTime187 , 0.0));
			float4 WorldSpaceTile12 = appendResult11;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float lerpResult179 = lerp( 0.0 , _NormalPower , ase_worldNormal.y);
			float3 Normals175 = UnpackScaleNormal( tex3D( _Normals_3D, WorldSpaceTile12.xyz ), lerpResult179 );
			o.Normal = Normals175;
			float2 panner127 = ( 1.0 * _Time.y * float2( 0.1,0.1 ) + ( WorldSpaceTile12 * 0.01 ).xy);
			float simplePerlin2D126 = snoise( panner127 );
			simplePerlin2D126 = simplePerlin2D126*0.5 + 0.5;
			float clampResult136 = clamp( ( tex2D( _Texture0, ( ( WorldSpaceTile12 / 20.0 ) * _DepthFoamTileWave ).xy ).r * ( simplePerlin2D126 + _DepthMaskIntensity ) ) , 0.0 , 1.0 );
			float DepthTexture123 = clampResult136;
			float temp_output_7_0 = ( _Time.y * 0.2 );
			float2 _Vector0 = float2(1,0.1);
			float4 WaveTileUV27 = ( ( WorldSpaceTile12 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner3 = ( temp_output_7_0 * _Vector0 + WaveTileUV27.xy);
			float simplePerlin2D2 = snoise( panner3 );
			simplePerlin2D2 = simplePerlin2D2*0.5 + 0.5;
			float2 panner29 = ( temp_output_7_0 * _Vector0 + ( WaveTileUV27 * float4( float2( 0.53,0.2 ), 0.0 , 0.0 ) ).xy);
			float simplePerlin2D30 = snoise( panner29 );
			simplePerlin2D30 = simplePerlin2D30*0.5 + 0.5;
			float WavePattern37 = ( ( simplePerlin2D2 + _WaveCount ) + ( simplePerlin2D30 + _WaveIntensity ) );
			float clampResult64 = clamp( WavePattern37 , 0.0 , 1.0 );
			float4 lerpResult62 = lerp( _waterColor , ( _TopColor + DepthTexture123 ) , clampResult64);
			float4 Albedo65 = lerpResult62;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor144 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( _Refractamount * Normals175 ) ).xy);
			float4 clampResult145 = clamp( screenColor144 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Refraction146 = clampResult145;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth149 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _RefractionDepth ) );
			float clampResult151 = clamp( ( 1.0 - distanceDepth149 ) , 0.0 , 1.0 );
			float RefractionDepth152 = clampResult151;
			float4 lerpResult154 = lerp( Albedo65 , Refraction146 , RefractionDepth152);
			o.Albedo = lerpResult154.rgb;
			float screenDepth68 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth68 = abs( ( screenDepth68 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Distance ) );
			float4 temp_cast_11 = (_DepthPower).xxxx;
			float4 clampResult80 = clamp( ( 1.0 - pow( ( ( ( distanceDepth68 + 1.0 ) + tex2D( _Texture0, ( ( WorldSpaceTile12 / 5.0 ) * _DeapthFoamTileEdge ).xy ) ) * _DepthMultiply ) , temp_cast_11 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 DepthFade78 = clampResult80;
			o.Emission = DepthFade78.rgb;
			o.Smoothness = _Smoothnes;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
				float4 screenPos : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
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
127;73;1655;703;1988.178;-782.9521;1.342582;True;False
Node;AmplifyShaderEditor.CommentaryNode;43;-2092.931,-612.9298;Inherit;False;2042.336;604.6885;WaveTile UV;14;27;16;17;14;13;15;12;11;187;181;183;184;10;182;WaveTile UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-2040.146,-462.9614;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;182;-2006.939,-184.6072;Inherit;False;Property;_NormalSpeedArray;NormalSpeedArray;11;0;Create;True;0;0;0;False;0;False;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2034.814,-271.6921;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;0;False;0;False;0.1;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;184;-1596.672,-474.0442;Inherit;False;120;124;U;1;186;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;183;-1595.86,-342.7572;Inherit;False;120;124;V;1;185;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;187;-1618.096,-179.8232;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-1593.672,-440.0442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1593.073,-308.6372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1357.189,-334.707;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1143.085,-337.7398;Inherit;False;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;15;-882.2589,-304.9123;Inherit;True;Property;_WaveStretch;WaveStretch;6;0;Create;True;0;0;0;False;0;False;1,0.1;1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;13;-917.7088,-495.9075;Inherit;True;12;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-678.8198,-392.6165;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-684.7348,-283.2307;Inherit;True;Property;_WaveTile;WaveTile;0;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-402.9937,-390.8759;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;137;-1899.281,1297.045;Inherit;False;1718.125;959.7307;Depth Texture;22;118;130;129;119;127;120;110;121;114;113;112;126;122;108;134;133;117;111;109;135;136;123;Depth Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1849.281,1722.309;Inherit;False;12;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1672.341,1946.155;Inherit;False;Constant;_TilingMask;TilingMask;20;0;Create;True;0;0;0;False;0;False;0.01;1.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2101.361,56.52979;Inherit;False;1654.526;735.3648;Wave Pattern;18;32;6;5;36;7;31;4;28;29;3;34;19;2;30;35;18;33;37;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-249.8916,-394.0526;Inherit;False;WaveTileUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-2051.361,347.9843;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;177;52.86091,-594.9753;Inherit;False;578.6055;362.3045;NormalPower;3;180;179;178;NormalPower;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1815.763,1808.272;Inherit;False;Constant;_DividedepthWave;DividedepthWave;17;0;Create;True;0;0;0;False;0;False;20;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-2026.334,617.9714;Inherit;False;Constant;_Wave2Mult;Wave2Mult;7;0;Create;True;0;0;0;False;0;False;0.53,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1501.075,1915.061;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2042.361,426.9844;Inherit;False;Constant;_NoiseSpeed;NoiseSpeed;0;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-2037.461,533.0668;Inherit;False;27;WaveTileUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1584.43,1819.568;Inherit;False;Property;_DepthFoamTileWave;DepthFoamTileWave;16;0;Create;True;0;0;0;False;0;False;1;3;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;180;77.75189,-453.0262;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;4;-1886.361,259.7843;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1905.044,130.8761;Inherit;False;27;WaveTileUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;-1551.355,1728.049;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1881.361,398.9844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;172;632.7726,-560.422;Inherit;False;793.8466;281.0519;Normals;3;175;174;173;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;127;-1327.942,1919.25;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1831.098,537.7311;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;178;61.7519,-538.0264;Inherit;False;Property;_NormalPower;NormalPower;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;3;-1608.561,113.9845;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;179;391.7185,-455.4582;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;660.733,-520.8171;Inherit;False;12;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;29;-1610.077,467.0983;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;81;-1412.75,926.593;Inherit;False;1921.77;331.7764;Depth;12;78;80;70;74;73;76;115;75;71;72;68;69;Depth Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1336.281,1730.309;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1816.544,1626.008;Inherit;False;Constant;_DividedepthEdge;DividedepthEdge;19;0;Create;True;0;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1164.761,2140.776;Inherit;False;Property;_DepthMaskIntensity;DepthMaskIntensity;17;0;Create;True;0;0;0;False;0;False;0;0;-1;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1846.063,1541.045;Inherit;False;12;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;108;-1536.063,1352.045;Inherit;True;Property;_Texture0;Texture 0;15;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NoiseGeneratorNode;126;-1135.26,1919.249;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;173;889.7115,-510.37;Inherit;True;Property;_Normals_3D;Normals_3D;5;0;Create;True;0;0;0;False;0;False;-1;8412d1f8d5b7c084081a79e0303b88f5;8412d1f8d5b7c084081a79e0303b88f5;True;0;False;white;LockedToTexture3D;True;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-1585.211,1645.304;Inherit;False;Property;_DeapthFoamTileEdge;DeapthFoamTileEdge;18;0;Create;True;0;0;0;False;0;False;2;3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;-1408.315,462.6435;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1397.75,1039.258;Inherit;False;Property;_Distance;Distance;12;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;113;-1548.137,1546.785;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1441.315,685.8948;Inherit;False;Property;_WaveIntensity;WaveIntensity;2;0;Create;True;0;0;0;False;0;False;0;-0.2;-1;0.8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-1134.087,1702.36;Inherit;True;Property;_TextureSample3;Texture Sample 3;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-1398.561,103.2923;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1436.942,327.5983;Inherit;False;Property;_WaveCount;WaveCount;1;0;Create;True;0;0;0;False;0;False;0;-0.2;-1;0.8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-843.5834,1922.408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;1202.618,-510.422;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-714.5365,1734.683;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;148;-276.9509,-1414.802;Inherit;False;1317.307;616.5884;Refraction;14;146;145;144;143;141;139;140;142;138;150;149;155;151;152;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1161.442,114.2982;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1043.069,1087.594;Inherit;False;Constant;_Bias;Bias;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1333.063,1549.045;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1149.941,465.7214;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;68;-1136.75,983.2583;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;136;-554.3987,1736.759;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-177.7704,-1113.801;Inherit;False;175;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;138;-226.9509,-1361.11;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;109;-1181.063,1347.045;Inherit;True;Property;_TextureSample2;Texture Sample 2;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-875.8008,299.1328;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-254.7704,-1189.802;Inherit;False;Property;_Refractamount;Refract amount;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-901.0699,983.5931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-778.8354,984.1105;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;139;37.22967,-1362.802;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-740.8346,293.6213;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-800.8641,1084.735;Inherit;False;Property;_DepthMultiply;DepthMultiply;13;0;Create;True;0;0;0;False;0;False;0;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;55.2298,-1169.801;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-405.1563,1731.443;Inherit;False;DepthTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-2075.156,-1427.554;Inherit;False;1021.002;677.6607;Albedo;8;65;62;48;64;125;61;63;124;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-261.8312,-969.6791;Inherit;False;Property;_RefractionDepth;Refraction Depth;20;0;Create;True;0;0;0;False;0;False;10;0;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;149;26.38615,-990.7189;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-526.8655,1153.735;Inherit;False;Property;_DepthPower;DepthPower;14;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-358.8654,989.736;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;61;-1982.725,-1202.361;Inherit;False;Property;_TopColor;TopColor;10;0;Create;True;0;0;0;False;0;False;0.4089979,0.7206899,0.8584906,1;0,0.372494,0.5377358,0.682353;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1970.406,-942.5077;Inherit;False;37;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1973.051,-1022.393;Inherit;False;123;DepthTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;270.2294,-1285.802;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;41;-416.6431,198.8579;Inherit;False;783.2075;411.1364;Height Wave;6;24;26;25;38;22;39;Height Wave;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;48;-1977.128,-1375.554;Inherit;False;Property;_waterColor;water Color;8;0;Create;True;0;0;0;False;0;False;0,0.1464853,0.5372549,1;0,0.372494,0.5377358,0.682353;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-410.6431,327.9944;Inherit;False;Property;_WaveHeight;WaveHeight;4;0;Create;True;0;0;0;False;0;False;4;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;74;-227.8654,990.1361;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1725.642,-1148.088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;144;413.2295,-1289.802;Inherit;False;Global;_GrabScreen0;Grab Screen 0;22;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;155;272.3583,-987.7038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;64;-1736.481,-970.079;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;24;-362.6431,421.9943;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;70;-89.94984,988.9584;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;62;-1512.488,-1360.293;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;145;616.5931,-1282.818;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;151;436.2819,-987.8688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-316.0378,248.8579;Inherit;False;37;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-144.6432,401.9943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;612.6069,-972.8578;Inherit;False;RefractionDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-10.22266,264.8321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;80;58.68365,989.8529;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1277.673,-1365.026;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;775.5931,-1287.818;Inherit;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;142.5642,260.1943;Inherit;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;300.9302,982.793;Inherit;False;DepthFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;669.905,165.7194;Inherit;False;152;RefractionDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;707.8634,90.35941;Inherit;False;146;Refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;714.6378,18.87436;Inherit;False;65;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;786.5787,448.6541;Inherit;False;Property;_Smoothnes;Smoothnes;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;626.4401,324.5266;Inherit;False;175;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;613.5813,247.561;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;158;664.771,788.0045;Inherit;False;Constant;_Float3;Float 3;23;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;643.2548,611.397;Inherit;False;Constant;_Tessellation;Tessellation;8;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;154;969.905,75.7194;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;188;935.6105,794.5639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;873.4438,372.5621;Inherit;False;78;DepthFade;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;902.9638,522.6904;Inherit;False;39;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;156;895.771,636.0045;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;157;665.771,694.0045;Inherit;False;Constant;_Float2;Float 2;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1184.485,240.218;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Tomas_Perez_HighQualityOcean 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;187;0;182;0
WireConnection;186;0;10;1
WireConnection;186;1;181;0
WireConnection;185;0;10;3
WireConnection;185;1;181;0
WireConnection;11;0;186;0
WireConnection;11;1;185;0
WireConnection;11;2;187;0
WireConnection;12;0;11;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;27;0;16;0
WireConnection;129;0;118;0
WireConnection;129;1;130;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;127;0;129;0
WireConnection;31;0;36;0
WireConnection;31;1;32;0
WireConnection;3;0;28;0
WireConnection;3;2;4;0
WireConnection;3;1;7;0
WireConnection;179;1;178;0
WireConnection;179;2;180;2
WireConnection;29;0;31;0
WireConnection;29;2;4;0
WireConnection;29;1;7;0
WireConnection;122;0;120;0
WireConnection;122;1;121;0
WireConnection;126;0;127;0
WireConnection;173;1;174;0
WireConnection;173;5;179;0
WireConnection;30;0;29;0
WireConnection;113;0;110;0
WireConnection;113;1;114;0
WireConnection;117;0;108;0
WireConnection;117;1;122;0
WireConnection;2;0;3;0
WireConnection;133;0;126;0
WireConnection;133;1;134;0
WireConnection;175;0;173;0
WireConnection;135;0;117;1
WireConnection;135;1;133;0
WireConnection;18;0;2;0
WireConnection;18;1;19;0
WireConnection;111;0;113;0
WireConnection;111;1;112;0
WireConnection;35;0;30;0
WireConnection;35;1;34;0
WireConnection;68;0;69;0
WireConnection;136;0;135;0
WireConnection;109;0;108;0
WireConnection;109;1;111;0
WireConnection;33;0;18;0
WireConnection;33;1;35;0
WireConnection;71;0;68;0
WireConnection;71;1;72;0
WireConnection;115;0;71;0
WireConnection;115;1;109;0
WireConnection;139;0;138;0
WireConnection;37;0;33;0
WireConnection;141;0;140;0
WireConnection;141;1;142;0
WireConnection;123;0;136;0
WireConnection;149;0;150;0
WireConnection;73;0;115;0
WireConnection;73;1;75;0
WireConnection;143;0;139;0
WireConnection;143;1;141;0
WireConnection;74;0;73;0
WireConnection;74;1;76;0
WireConnection;125;0;61;0
WireConnection;125;1;124;0
WireConnection;144;0;143;0
WireConnection;155;0;149;0
WireConnection;64;0;63;0
WireConnection;70;0;74;0
WireConnection;62;0;48;0
WireConnection;62;1;125;0
WireConnection;62;2;64;0
WireConnection;145;0;144;0
WireConnection;151;0;155;0
WireConnection;25;0;26;0
WireConnection;25;1;24;0
WireConnection;152;0;151;0
WireConnection;22;0;38;0
WireConnection;22;1;25;0
WireConnection;80;0;70;0
WireConnection;65;0;62;0
WireConnection;146;0;145;0
WireConnection;39;0;22;0
WireConnection;78;0;80;0
WireConnection;154;0;66;0
WireConnection;154;1;147;0
WireConnection;154;2;153;0
WireConnection;156;0;20;0
WireConnection;156;1;157;0
WireConnection;156;2;158;0
WireConnection;0;0;154;0
WireConnection;0;1;176;0
WireConnection;0;2;79;0
WireConnection;0;4;44;0
WireConnection;0;11;40;0
WireConnection;0;14;188;0
ASEEND*/
//CHKSM=C82104809AB64BBD9E98DB3F4B0510215142FA72