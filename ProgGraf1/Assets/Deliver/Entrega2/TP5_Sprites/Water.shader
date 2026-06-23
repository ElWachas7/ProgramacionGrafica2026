// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_DistortionSpeed("Distortion Speed", Vector) = (0,0,0,0)
		_ImpactPosition("ImpactPosition", Vector) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WaveAmplitude("Wave Amplitude", Range( 0 , 4)) = 2.42703
		_WaveSpeed("Wave Speed", Range( 0 , 4)) = 0.931611
		_Opacity("Opacity", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _WaveFrequency;
		uniform float _WaveSpeed;
		uniform float _WaveAmplitude;
		uniform float3 _ImpactPosition;
		uniform sampler2D _TextureSample0;
		uniform float2 _DistortionSpeed;
		uniform float _Opacity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float mulTime6 = _Time.y * 0.3779937;
			float4 screenColor65 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( sin( ( ( (ase_screenPosNorm).xy * _WaveFrequency ) + ( mulTime6 * ( _WaveSpeed * 6.28318548202515 ) ) ) ) * _WaveAmplitude ));
			float4 appendResult68 = (float4(screenColor65.r , screenColor65.g , 0.0 , 0.0));
			float4 WaterAmplitude43 = appendResult68;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 ImpactZone45 = ( WaterAmplitude43 + sin( ( distance( ase_worldPos , _ImpactPosition ) - _Time.y ) ) );
			float4 appendResult38 = (float4(0.0 , 0.0 , ( ( 1.0 - saturate( ( (ase_vertex3Pos).z - 3.0 ) ) ) * ImpactZone45 ).xy));
			float4 Offset62 = appendResult38;
			v.vertex.xyz += Offset62.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner53 = ( _Time.y * _DistortionSpeed + i.uv_texcoord);
			float4 break57 = tex2D( _TextureSample0, panner53 );
			float4 appendResult58 = (float4(break57.r , break57.g , break57.b , 1.0));
			float4 Albedo54 = appendResult58;
			o.Albedo = Albedo54.xyz;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
265.6;80.8;849.2;423.8;2559.159;278.3059;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-3536.13,-450.5119;Inherit;False;1486.115;566.7827;;14;25;20;19;16;13;10;9;7;6;5;4;2;67;65;Movimiento Olas;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3492.972,-101.4731;Inherit;False;Property;_WaveSpeed;Wave Speed;5;0;Create;True;0;0;0;False;0;False;0.931611;0.931611;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3491.13,-180.4781;Inherit;False;Constant;_LinearSpeed;LinearSpeed;13;0;Create;True;0;0;0;False;0;False;0.3779937;0.249;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;2;-3410.534,-18.74903;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;66;-3672.266,-369.0427;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;6;-3165.131,-174.4781;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;67;-3413.494,-371.5534;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-3165.46,-96.72914;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3489.652,-259.0803;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2974.13,-174.4781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-3156.584,-363.0804;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2804.53,-362.3118;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2775.937,-145.1234;Inherit;False;Property;_WaveAmplitude;Wave Amplitude;4;0;Create;True;0;0;0;False;0;False;2.42703;0.62;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-2677.529,-362.3118;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;47;-3531.748,176.2642;Inherit;False;1198.314;508.6094;Impact Zone;9;45;30;44;27;17;21;11;15;12;Impact Zone;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2481.015,-209.1236;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-3494.154,353.4322;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;11;-3491.547,503.7168;Inherit;False;Property;_ImpactPosition;ImpactPosition;2;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenColorNode;65;-2300.283,-210.4713;Inherit;False;Global;_GrabScreen1;Grab Screen 0;9;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;15;-3250.427,353.411;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;68;-2125.571,-214.334;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-3259.581,461.382;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;-2285.636,177.8604;Inherit;False;1438.122;401.8242;Offset;9;14;18;23;28;46;32;36;38;62;Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;14;-2235.635,233.2673;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-3076.96,352.6756;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1968.286,-226.6758;Inherit;False;WaterAmplitude;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2995.589,260.9202;Inherit;False;43;WaterAmplitude;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;56;-3507.792,763.5949;Inherit;False;1326.055;406.1125;Albedo;8;54;58;57;48;53;52;50;51;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;27;-2909.262,352.7698;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;18;-2063.936,229.8604;Inherit;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-2711.915,266.3965;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;52;-3435.111,958.8084;Inherit;False;Property;_DistortionSpeed;Distortion Speed;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-1879.936,227.8604;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-3465.382,839.263;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;50;-3415.834,1082.46;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2571.245,260.8308;Inherit;False;ImpactZone;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;53;-3181.216,841.7682;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;28;-1747.936,238.8604;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1715.8,464.2846;Inherit;False;45;ImpactZone;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;32;-1642.936,317.8604;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-2998.245,813.5949;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1448.245,391.2365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;57;-2680.215,887.4837;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1288.307,379.5911;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-2520.354,887.7608;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1072.313,429.123;Inherit;False;Offset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-2378.091,881.8396;Inherit;False;Albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-716.1768,495.4888;Inherit;False;62;Offset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3670.584,-566.0803;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-663.5652,216.7939;Inherit;False;54;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-720.3065,426.3764;Inherit;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-456.4741,221.0151;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;67;0;66;0
WireConnection;7;0;4;0
WireConnection;7;1;2;0
WireConnection;10;0;6;0
WireConnection;10;1;7;0
WireConnection;13;0;67;0
WireConnection;13;1;9;0
WireConnection;16;0;13;0
WireConnection;16;1;10;0
WireConnection;20;0;16;0
WireConnection;25;0;20;0
WireConnection;25;1;19;0
WireConnection;65;0;25;0
WireConnection;15;0;12;0
WireConnection;15;1;11;0
WireConnection;68;0;65;1
WireConnection;68;1;65;2
WireConnection;21;0;15;0
WireConnection;21;1;17;0
WireConnection;43;0;68;0
WireConnection;27;0;21;0
WireConnection;18;0;14;0
WireConnection;30;0;44;0
WireConnection;30;1;27;0
WireConnection;23;0;18;0
WireConnection;45;0;30;0
WireConnection;53;0;51;0
WireConnection;53;2;52;0
WireConnection;53;1;50;0
WireConnection;28;0;23;0
WireConnection;32;0;28;0
WireConnection;48;1;53;0
WireConnection;36;0;32;0
WireConnection;36;1;46;0
WireConnection;57;0;48;0
WireConnection;38;2;36;0
WireConnection;58;0;57;0
WireConnection;58;1;57;1
WireConnection;58;2;57;2
WireConnection;62;0;38;0
WireConnection;54;0;58;0
WireConnection;0;0;55;0
WireConnection;0;9;60;0
WireConnection;0;11;63;0
ASEEND*/
//CHKSM=BF21948F519080545B2357E879DFFA58B754F12D