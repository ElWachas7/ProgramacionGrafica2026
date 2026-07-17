// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BuubleShiel"
{
	Properties
	{
		_displacementStrenght("_displacementStrenght", Range( 0 , 1)) = 0.5
		_fresnelPow("_fresnelPow", Range( 0 , 5)) = 0
		_disolve("_disolve", Range( -1 , 2)) = 0.5730416
		_disolveEdge("_disolveEdge", Range( -1 , 2)) = 0.221288
		_TwirldStrenght("Twirld Strenght", Range( -20 , 20)) = 9.003157
		_zoom("zoom", Range( -1 , 0.5)) = 0
		_SpinSpeed("SpinSpeed", Range( 0 , 5)) = 1
		_SpiralStepMin("SpiralStepMin", Range( 0 , 1)) = 0.6352941
		_hardness("_hardness", Range( 0 , 1)) = 0.2763902
		_SpiralStepMax("SpiralStepMax", Range( 1 , 2)) = 2
		_hitPos("_hitPos", Vector) = (0.5,0.5,0.5,0)
		_radius("_radius", Range( 0 , 15)) = 0
		_shieldColor("_shieldColor", Color) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="TransparentCutout" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		GrabPass{ }

		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _hardness;
			uniform float3 _hitPos;
			uniform float _radius;
			uniform float _displacementStrenght;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _zoom;
			uniform float _TwirldStrenght;
			uniform float _SpinSpeed;
			uniform float _SpiralStepMin;
			uniform float _SpiralStepMax;
			uniform float _disolve;
			uniform float _disolveEdge;
			uniform float _fresnelPow;
			uniform float4 _shieldColor;
					float2 voronoihash193( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi193( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash193( n + g );
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float _hardness222 = _hardness;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 _hitPosition175 = _hitPos;
				float _radius221 = _radius;
				float smoothstepResult144 = smoothstep( _hardness222 , 1.0 , saturate( ( 1.0 - ( distance( ase_worldPos , _hitPosition175 ) / _radius221 ) ) ));
				float3 Displacement153 = ( ( v.ase_normal * smoothstepResult144 ) * _displacementStrenght );
				
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = Displacement153;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 appendResult167 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
				float _hardness222 = _hardness;
				float3 _hitPosition175 = _hitPos;
				float _radius221 = _radius;
				float smoothstepResult163 = smoothstep( _hardness222 , 1.0 , saturate( ( 1.0 - ( distance( WorldPosition , _hitPosition175 ) / _radius221 ) ) ));
				float temp_output_165_0 = ( smoothstepResult163 * _zoom );
				float4 Zoom301 = ( ( appendResult167 * ( 1.0 - temp_output_165_0 ) ) + float4( ( temp_output_165_0 * float2( 0.5,0.5 ) ), 0.0 , 0.0 ) );
				float time193 = ( _Time.y * 2.0 );
				float2 texCoord47_g1 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _TwirlCenter = float2(0,0);
				float2 center45_g1 = _TwirlCenter;
				float2 delta6_g1 = ( texCoord47_g1 - center45_g1 );
				float angle10_g1 = ( length( delta6_g1 ) * _TwirldStrenght );
				float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
				float2 break40_g1 = center45_g1;
				float2 break41_g1 = float2( 0,0 );
				float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
				float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
				float cos191 = cos( ( _SpinSpeed * _Time.y ) );
				float sin191 = sin( ( _SpinSpeed * _Time.y ) );
				float2 rotator191 = mul( appendResult44_g1 - _TwirlCenter , float2x2( cos191 , -sin191 , sin191 , cos191 )) + _TwirlCenter;
				float2 coords193 = rotator191 * 5.0;
				float2 id193 = 0;
				float2 uv193 = 0;
				float voroi193 = voronoi193( coords193, time193, id193, uv193, 0 );
				float Spiral199 = (-0.1 + (voroi193 - 0.0) * (1.0 - -0.1) / (1.0 - 0.0));
				float2 texCoord179 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break185 = (float2( -1,-1 ) + (texCoord179 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float4 appendResult190 = (float4(break185.x , break185.y , 0.0 , 0.0));
				float smoothstepResult197 = smoothstep( _SpiralStepMin , _SpiralStepMax , length( appendResult190 ));
				float SmoothStepSpiral198 = smoothstepResult197;
				float4 screenColor207 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( Zoom301 + ( ( Spiral199 * SmoothStepSpiral198 ) * 0.8 ) ).xy);
				float Disolve252 = _disolve;
				float disolveEdge253 = ( _disolve + _disolveEdge );
				float simplePerlin2D245 = snoise( WorldPosition.xy*0.1 );
				simplePerlin2D245 = simplePerlin2D245*0.5 + 0.5;
				float4 transform235 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
				float4 appendResult234 = (float4(-ase_objectScale.x , ase_objectScale.x , 0.0 , 0.0));
				float4 Scale238 = ( transform235.y + appendResult234 );
				float4 break241 = Scale238;
				float GrainDisolve254 = ( ( simplePerlin2D245 * 0.5 ) + ( 1.0 - (0.0 + (WorldPosition.y - break241.x) * (1.0 - 0.0) / (break241.y - break241.x)) ) );
				float smoothstepResult259 = smoothstep( Disolve252 , disolveEdge253 , GrainDisolve254);
				float Edge271 = _disolveEdge;
				float smoothstepResult268 = smoothstep( disolveEdge253 , ( disolveEdge253 + Edge271 ) , GrainDisolve254);
				float EdgeShield272 = ( smoothstepResult259 - smoothstepResult268 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float fresnelNdotV282 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode282 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV282, _fresnelPow ) );
				float4 Fresnel299 = saturate( ( fresnelNode282 * _shieldColor ) );
				float Alpha260 = smoothstepResult259;
				
				
				finalColor = saturate( ( ( ( screenColor207 + EdgeShield272 ) + Fresnel299 ) * Alpha260 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;605;1538;394;3422.046;4530.25;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;231;-2433.274,-2039.783;Inherit;False;872.2297;385.1786;Scale object problem;6;238;236;235;234;233;232;Scale object problem;1,1,1,1;0;0
Node;AmplifyShaderEditor.ObjectScaleNode;232;-2404.291,-1806.404;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;174;-4980.083,-3136.506;Inherit;False;2199.631;567.3586;Zoom;21;171;170;169;168;166;167;165;164;173;163;161;162;160;159;157;158;175;156;155;221;222;Zoom;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;233;-2210.291,-1832.304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;155;-4955.027,-2896.506;Inherit;False;Property;_hitPos;_hitPos;10;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5;0.5,0.5,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-4744.752,-2900.253;Inherit;False;_hitPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;234;-2058.389,-1807.904;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;235;-2406.675,-1987.183;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;156;-4781.027,-3086.506;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;157;-4965.251,-2734.797;Inherit;False;Property;_radius;_radius;11;0;Create;True;0;0;0;False;0;False;0;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;158;-4498.819,-2997.941;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;236;-1918.443,-1940.8;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;177;-4896.529,-3755.299;Inherit;False;1537.007;494.1284;SmoothStepSpiral;9;198;197;195;194;192;190;185;183;179;SmoothStepSpiral;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;-4652.052,-2797.745;Inherit;False;_radius;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;159;-4354.819,-2997.941;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;179;-4846.529,-3704.659;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;237;-2444.104,-2654.702;Inherit;False;1395.476;565.4958;Grain Disolve ;10;254;250;248;247;245;243;242;241;240;239;Grain Disolve ;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;178;-4918.756,-4585.966;Inherit;False;1630.566;652.5834;Spiral;12;199;196;193;191;189;188;187;186;184;182;181;180;Spiral;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;238;-1784.507,-1936.971;Inherit;False;Scale;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;160;-4235.819,-2997.941;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;239;-2394.104,-2549.702;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;181;-4775.926,-4217.525;Inherit;False;Property;_SpinSpeed;SpinSpeed;6;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;183;-4599.963,-3704.428;Inherit;True;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-4955.755,-2651.463;Inherit;False;Property;_hardness;_hardness;8;0;Create;True;0;0;0;False;0;False;0.2763902;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;240;-2288.025,-2252.82;Inherit;False;238;Scale;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-4868.756,-4494.966;Inherit;False;Property;_TwirldStrenght;Twirld Strenght;4;0;Create;True;0;0;0;False;0;False;9.003157;0;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;184;-4674.927,-4137.525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;180;-4774.757,-4347.966;Inherit;False;Constant;_TwirlCenter;Twirl Center;6;0;Create;True;0;0;0;False;0;False;0,0;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-4404.926,-4212.525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-4772.343,-4057.68;Inherit;False;Constant;_angleSpeed;angleSpeed;2;0;Create;True;0;0;0;False;0;False;2;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;241;-2118.12,-2260.308;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;161;-4093.819,-2997.941;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;242;-2186.104,-2466.702;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-4568.052,-2681.745;Inherit;False;_hardness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;185;-4310.258,-3704.299;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;186;-4513.758,-4535.966;Inherit;True;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;244;-1507.25,-2031.846;Inherit;False;745.8663;400.9252;Disolve + edge;6;271;253;252;251;249;246;Disolve + edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;243;-1873.104,-2379.702;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-4007.644,-2770.849;Inherit;False;Property;_zoom;zoom;5;0;Create;True;0;0;0;False;0;False;0;0;-1;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-1466.25,-1739.846;Inherit;False;Property;_disolveEdge;_disolveEdge;3;0;Create;True;0;0;0;False;0;False;0.221288;0;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;163;-3932.563,-2913.39;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;245;-1971.104,-2555.702;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;1,1;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-4404.623,-4097.309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;190;-4178.258,-3704.299;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-1457.25,-1981.847;Inherit;False;Property;_disolve;_disolve;2;0;Create;True;0;0;0;False;0;False;0.5730416;0;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;191;-4187.758,-4365.966;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-4158.258,-3384.298;Inherit;False;Property;_SpiralStepMax;SpiralStepMax;9;0;Create;True;0;0;0;False;0;False;2;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-1730.104,-2604.702;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;192;-4040.26,-3705.299;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;251;-1118.25,-1865.846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-4162.258,-3475.298;Inherit;False;Property;_SpiralStepMin;SpiralStepMin;7;0;Create;True;0;0;0;False;0;False;0.6352941;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-3678.052,-2806.027;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;164;-3698.107,-3011.636;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;193;-3928.759,-4354.966;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;247;-1601.104,-2378.702;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;166;-3435.707,-2834.336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;167;-3511.107,-2982.636;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;-1442.618,-2400.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;197;-3814.26,-3594.298;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;152;-4994.638,-2441.308;Inherit;False;2094.972;744.0155;Displacement;14;153;137;148;147;146;144;145;143;141;140;139;176;223;224;Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;196;-3758.202,-4354.677;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;255;-2430.001,-3302.807;Inherit;False;1342.68;554.3213;Disolve transition;10;273;272;268;267;262;260;259;258;257;256;Disolve transition;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;253;-967.6233,-1869.846;Inherit;False;disolveEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;271;-968.6234,-1739.846;Inherit;False;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;168;-3646.707,-2703.336;Inherit;False;Constant;_ObjScreenPos;_ObjScreenPos;7;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;258;-2361.457,-3016.835;Inherit;False;253;disolveEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-4795.639,-2064.355;Inherit;False;175;_hitPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-3259.707,-2882.336;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;137;-4944.638,-2224.906;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;300;-3121.014,-4583.598;Inherit;False;1386.793;481.8232;Fresnel;6;290;282;283;284;298;299;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-3363.707,-2723.336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;-2380.001,-3179.38;Inherit;False;271;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;252;-966.6233,-1984.846;Inherit;False;Disolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;-3579.835,-3599.985;Inherit;False;SmoothStepSpiral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-3490.327,-4359.667;Inherit;False;Spiral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;-1307.726,-2400.61;Inherit;False;GrainDisolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;139;-4509.59,-2194.411;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;-4558.244,-2032.772;Inherit;False;221;_radius;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-3111.707,-2881.336;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-930.6067,-3992.4;Inherit;False;199;Spiral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;-2126.523,-3199.181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;-2237.553,-2912.091;Inherit;False;252;Disolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;-980.5237,-3892.426;Inherit;False;198;SmoothStepSpiral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;-2116.527,-3062.192;Inherit;False;254;GrainDisolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;290;-3071.014,-4438.258;Inherit;False;Property;_fresnelPow;_fresnelPow;1;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-707.4817,-3835.568;Inherit;False;Constant;_Intensity;Intensity;2;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;282;-2749.352,-4533.598;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;301;-2952.223,-2867.52;Inherit;False;Zoom;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;283;-2736.84,-4313.775;Inherit;False;Property;_shieldColor;_shieldColor;12;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;259;-1884.57,-3002.486;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;268;-1882.821,-3244.509;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;140;-4365.589,-2194.411;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-710.2026,-3969.4;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-491.7729,-4045.451;Inherit;False;301;Zoom;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;262;-1545.383,-3252.807;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-530.4817,-3970.568;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;141;-4246.59,-2194.411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-2420.546,-4469.209;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;-4236.244,-2052.772;Inherit;False;222;_hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;143;-4104.59,-2194.411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;-264.0256,-3997.343;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;-1311.322,-3244.511;Inherit;False;EdgeShield;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;298;-2236.181,-4377.449;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;207;-16.12336,-3988.165;Inherit;False;Global;_GrabScreen1;Grab Screen 1;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;144;-3943.334,-2109.86;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;145;-3910.452,-2294.002;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;278;157.006,-3871.407;Inherit;False;272;EdgeShield;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-1958.221,-4368.715;Inherit;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-3868.023,-1984.056;Inherit;False;Property;_displacementStrenght;_displacementStrenght;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-3698.445,-2110.727;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;303;359.9289,-3871.516;Inherit;False;299;Fresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;277;357.0062,-3982.407;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;-1501.262,-2982.322;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-3547.023,-2110.056;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;532.7418,-3981.948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;543.9952,-3864.48;Inherit;False;260;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;698.033,-3982.038;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;-3315.65,-2116.138;Inherit;False;Displacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;746.2713,-3856.995;Inherit;False;153;Displacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;304;838.6802,-3982.573;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;230;973.5566,-3980.5;Float;False;True;-1;2;ASEMaterialInspector;100;1;BuubleShiel;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;True;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=TransparentCutout=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;233;0;232;1
WireConnection;175;0;155;0
WireConnection;234;0;233;0
WireConnection;234;1;232;1
WireConnection;158;0;156;0
WireConnection;158;1;175;0
WireConnection;236;0;235;2
WireConnection;236;1;234;0
WireConnection;221;0;157;0
WireConnection;159;0;158;0
WireConnection;159;1;221;0
WireConnection;238;0;236;0
WireConnection;160;0;159;0
WireConnection;183;0;179;0
WireConnection;188;0;181;0
WireConnection;188;1;184;0
WireConnection;241;0;240;0
WireConnection;161;0;160;0
WireConnection;242;0;239;0
WireConnection;222;0;162;0
WireConnection;185;0;183;0
WireConnection;186;2;180;0
WireConnection;186;3;182;0
WireConnection;243;0;242;1
WireConnection;243;1;241;0
WireConnection;243;2;241;1
WireConnection;163;0;161;0
WireConnection;163;1;222;0
WireConnection;245;0;239;0
WireConnection;189;0;184;0
WireConnection;189;1;187;0
WireConnection;190;0;185;0
WireConnection;190;1;185;1
WireConnection;191;0;186;0
WireConnection;191;1;180;0
WireConnection;191;2;188;0
WireConnection;248;0;245;0
WireConnection;192;0;190;0
WireConnection;251;0;246;0
WireConnection;251;1;249;0
WireConnection;165;0;163;0
WireConnection;165;1;173;0
WireConnection;193;0;191;0
WireConnection;193;1;189;0
WireConnection;247;0;243;0
WireConnection;166;0;165;0
WireConnection;167;0;164;1
WireConnection;167;1;164;2
WireConnection;250;0;248;0
WireConnection;250;1;247;0
WireConnection;197;0;192;0
WireConnection;197;1;194;0
WireConnection;197;2;195;0
WireConnection;196;0;193;0
WireConnection;253;0;251;0
WireConnection;271;0;249;0
WireConnection;170;0;167;0
WireConnection;170;1;166;0
WireConnection;169;0;165;0
WireConnection;169;1;168;0
WireConnection;252;0;246;0
WireConnection;198;0;197;0
WireConnection;199;0;196;0
WireConnection;254;0;250;0
WireConnection;139;0;137;0
WireConnection;139;1;176;0
WireConnection;171;0;170;0
WireConnection;171;1;169;0
WireConnection;267;0;258;0
WireConnection;267;1;273;0
WireConnection;282;3;290;0
WireConnection;301;0;171;0
WireConnection;259;0;256;0
WireConnection;259;1;257;0
WireConnection;259;2;258;0
WireConnection;268;0;256;0
WireConnection;268;1;258;0
WireConnection;268;2;267;0
WireConnection;140;0;139;0
WireConnection;140;1;223;0
WireConnection;202;0;201;0
WireConnection;202;1;200;0
WireConnection;262;0;259;0
WireConnection;262;1;268;0
WireConnection;204;0;202;0
WireConnection;204;1;203;0
WireConnection;141;0;140;0
WireConnection;284;0;282;0
WireConnection;284;1;283;0
WireConnection;143;0;141;0
WireConnection;206;0;302;0
WireConnection;206;1;204;0
WireConnection;272;0;262;0
WireConnection;298;0;284;0
WireConnection;207;0;206;0
WireConnection;144;0;143;0
WireConnection;144;1;224;0
WireConnection;299;0;298;0
WireConnection;146;0;145;0
WireConnection;146;1;144;0
WireConnection;277;0;207;0
WireConnection;277;1;278;0
WireConnection;260;0;259;0
WireConnection;148;0;146;0
WireConnection;148;1;147;0
WireConnection;285;0;277;0
WireConnection;285;1;303;0
WireConnection;281;0;285;0
WireConnection;281;1;280;0
WireConnection;153;0;148;0
WireConnection;304;0;281;0
WireConnection;230;0;304;0
WireConnection;230;1;154;0
ASEEND*/
//CHKSM=C6604865B6B385799972E8CD7C93A5A49FC4E606