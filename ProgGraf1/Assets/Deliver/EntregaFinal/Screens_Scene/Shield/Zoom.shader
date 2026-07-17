// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Zoom"
{
	Properties
	{
		_zoom("zoom", Range( -1 , 0.5)) = 0
		_ObjScreenPos("_ObjScreenPos", Vector) = (0.5,0.5,0,0)
		_hardness("_hardness", Range( 0 , 1)) = 0.2763902
		_hitPos("_hitPos", Vector) = (0.5,0.5,0.5,0)
		_radius("_radius", Range( 0 , 15)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _hardness;
			uniform float3 _hitPos;
			uniform float _radius;
			uniform float _zoom;
			uniform float2 _ObjScreenPos;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
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
				float4 appendResult16 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
				float smoothstepResult41 = smoothstep( _hardness , 1.0 , saturate( ( 1.0 - ( distance( WorldPosition , _hitPos ) / _radius ) ) ));
				float temp_output_43_0 = ( smoothstepResult41 * _zoom );
				float4 screenColor7 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( appendResult16 * ( 1.0 - temp_output_43_0 ) ) + float4( ( temp_output_43_0 * _ObjScreenPos ), 0.0 , 0.0 ) ).xy);
				
				
				finalColor = screenColor7;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;536;1547;463;3208.226;801.8797;2.490984;True;False
Node;AmplifyShaderEditor.Vector3Node;28;-1998.075,-12.90858;Inherit;False;Property;_hitPos;_hitPos;3;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5;0.5,0.5,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-2029.075,-201.9081;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-1797.867,36.65656;Inherit;False;Property;_radius;_radius;4;0;Create;True;0;0;0;False;0;False;0;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;29;-1746.867,-113.3434;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-1602.867,-113.3434;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-1483.867,-113.3434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-1341.867,-113.3434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1499.803,-10.86555;Inherit;False;Property;_hardness;_hardness;2;0;Create;True;0;0;0;False;0;False;0.2763902;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;41;-1180.611,-28.79223;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1167.476,117.016;Inherit;False;Property;_zoom;zoom;0;0;Create;True;0;0;0;False;0;False;0;0;-1;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;9;-857.7549,-125.7383;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-926.1003,78.57079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-683.7549,50.26167;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-670.7549,-96.7383;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;23;-894.7549,181.2616;Inherit;False;Property;_ObjScreenPos;_ObjScreenPos;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-611.7549,161.2616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-507.7549,2.261672;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-359.7549,3.261672;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;7;-224.5,-3.499985;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;True;-1;2;ASEMaterialInspector;100;1;Zoom;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;32;0;30;0
WireConnection;33;0;32;0
WireConnection;41;0;33;0
WireConnection;41;1;42;0
WireConnection;43;0;41;0
WireConnection;43;1;12;0
WireConnection;21;0;43;0
WireConnection;16;0;9;1
WireConnection;16;1;9;2
WireConnection;24;0;43;0
WireConnection;24;1;23;0
WireConnection;17;0;16;0
WireConnection;17;1;21;0
WireConnection;20;0;17;0
WireConnection;20;1;24;0
WireConnection;7;0;20;0
WireConnection;6;0;7;0
ASEEND*/
//CHKSM=02AE1BC5D0BA526DB4BDA18EE85525EE8EE0A0CE