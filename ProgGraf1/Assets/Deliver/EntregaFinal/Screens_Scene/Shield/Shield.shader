// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield"
{
	Properties
	{
		_TwirldStrenght("Twirld Strenght", Range( -20 , 20)) = 9.003157
		_TwirlCenter("Twirl Center", Vector) = (0,0,0,0)
		_SpinSpeed("SpinSpeed", Range( 0 , 5)) = 1
		_SpiralStepMin("SpiralStepMin", Range( 0 , 1)) = 0.6352941
		_SpiralStepMax("SpiralStepMax", Range( 1 , 2)) = 2

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float2 _TwirlCenter;
			uniform float _TwirldStrenght;
			uniform float _SpinSpeed;
			uniform float _SpiralStepMin;
			uniform float _SpiralStepMax;
					float2 voronoihash17( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi17( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash17( n + g );
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
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
				float time17 = ( _Time.y * 2.0 );
				float2 texCoord47_g1 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 center45_g1 = _TwirlCenter;
				float2 delta6_g1 = ( texCoord47_g1 - center45_g1 );
				float angle10_g1 = ( length( delta6_g1 ) * _TwirldStrenght );
				float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
				float2 break40_g1 = center45_g1;
				float2 break41_g1 = float2( 0,0 );
				float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
				float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
				float cos23 = cos( ( _SpinSpeed * _Time.y ) );
				float sin23 = sin( ( _SpinSpeed * _Time.y ) );
				float2 rotator23 = mul( appendResult44_g1 - _TwirlCenter , float2x2( cos23 , -sin23 , sin23 , cos23 )) + _TwirlCenter;
				float2 coords17 = rotator23 * 5.0;
				float2 id17 = 0;
				float2 uv17 = 0;
				float voroi17 = voronoi17( coords17, time17, id17, uv17, 0 );
				float Spiral55 = (-0.1 + (voroi17 - 0.0) * (1.0 - -0.1) / (1.0 - 0.0));
				float2 texCoord43 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break48 = (float2( -1,-1 ) + (texCoord43 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float4 appendResult49 = (float4(break48.x , break48.y , 0.0 , 0.0));
				float smoothstepResult51 = smoothstep( _SpiralStepMin , _SpiralStepMax , length( appendResult49 ));
				float SmoothStepSpiral57 = smoothstepResult51;
				float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_screenPosNorm + ( ( Spiral55 * SmoothStepSpiral57 ) * 0.8 ) ).xy);
				
				
				finalColor = screenColor1;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;546;1547;453;2746.032;597.2458;1.743162;False;False
Node;AmplifyShaderEditor.CommentaryNode;56;-2196.734,406.0299;Inherit;False;1537.007;494.1284;SmoothStepSpiral;9;53;52;44;48;43;49;50;51;57;SmoothStepSpiral;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2218.961,-424.6341;Inherit;False;1630.566;652.5834;Spiral;12;35;17;23;33;18;26;34;19;20;28;27;55;Spiral;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-2146.734,456.6701;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;20;-2074.962,-186.6343;Inherit;False;Property;_TwirlCenter;Twirl Center;1;0;Create;True;0;0;0;False;0;False;0,0;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;28;-2076.131,-56.19388;Inherit;False;Property;_SpinSpeed;SpinSpeed;2;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2168.961,-333.6341;Inherit;False;Property;_TwirldStrenght;Twirld Strenght;0;0;Create;True;0;0;0;False;0;False;9.003157;0;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;44;-1900.168,456.9008;Inherit;True;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1975.132,23.80614;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;-1610.463,457.0299;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;18;-1813.963,-374.6341;Inherit;True;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2072.548,103.6498;Inherit;False;Constant;_angleSpeed;angleSpeed;2;0;Create;True;0;0;0;False;0;False;2;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1705.131,-51.19388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1704.827,64.02274;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1478.463,457.0299;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RotatorNode;23;-1487.963,-204.6343;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;50;-1340.464,456.0299;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;17;-1228.963,-193.6343;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;52;-1462.463,686.0303;Inherit;False;Property;_SpiralStepMin;SpiralStepMin;3;0;Create;True;0;0;0;False;0;False;0.6352941;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1458.463,777.0303;Inherit;False;Property;_SpiralStepMax;SpiralStepMax;4;0;Create;True;0;0;0;False;0;False;2;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;-1058.406,-193.3459;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;51;-1114.464,567.0303;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-880.0389,561.3434;Inherit;False;SmoothStepSpiral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-790.5303,-198.3354;Inherit;False;Spiral;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-572.9402,317.7999;Inherit;False;57;SmoothStepSpiral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-525.6191,217.8255;Inherit;False;55;Spiral;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-302.6191,240.8255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-299.8984,374.6581;Inherit;False;Constant;_Intensity;Intensity;2;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-122.8984,239.6581;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;39;-114.1218,60.42986;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;143.5571,212.8831;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;1;391.4592,222.0611;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;600.4822,222.2477;Float;False;True;-1;2;ASEMaterialInspector;100;1;Shield;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;44;0;43;0
WireConnection;48;0;44;0
WireConnection;18;2;20;0
WireConnection;18;3;19;0
WireConnection;26;0;28;0
WireConnection;26;1;27;0
WireConnection;33;0;27;0
WireConnection;33;1;34;0
WireConnection;49;0;48;0
WireConnection;49;1;48;1
WireConnection;23;0;18;0
WireConnection;23;1;20;0
WireConnection;23;2;26;0
WireConnection;50;0;49;0
WireConnection;17;0;23;0
WireConnection;17;1;33;0
WireConnection;35;0;17;0
WireConnection;51;0;50;0
WireConnection;51;1;52;0
WireConnection;51;2;53;0
WireConnection;57;0;51;0
WireConnection;55;0;35;0
WireConnection;58;0;59;0
WireConnection;58;1;60;0
WireConnection;37;0;58;0
WireConnection;37;1;38;0
WireConnection;40;0;39;0
WireConnection;40;1;37;0
WireConnection;1;0;40;0
WireConnection;16;0;1;0
ASEEND*/
//CHKSM=6FE199F6469613F6E660849041FEF74CB8362197