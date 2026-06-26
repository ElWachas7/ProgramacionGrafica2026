// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water_Shader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_WaveFrequency("Wave Frequency", Range( 0 , 4)) = 2.42703
		_WaveAmplitude("Wave Amplitude", Range( 0 , 3)) = 0
		_TimeSpeed("TimeSpeed", Float) = 2
		_WaterColor("_WaterColor", Color) = (0.2541118,0.7452364,0.7830189,0.7803922)
		_FrequencyX("FrequencyX", Float) = 8
		_FoamColor("FoamColor", Color) = (0.6735849,0.9758211,1,0.7803922)
		_WaveSpeed("Wave Speed", Range( 0 , 4)) = 0.931611
		_FrequencyY("FrequencyY", Float) = 5
		_AmplitudeY("AmplitudeY", Float) = 0.02
		_AmplitudeX("AmplitudeX", Float) = 0.02
		_Player("_Player", Vector) = (0,0,0,0)
		_FoamRadius("FoamRadius", Float) = 0
		_LinearSpeed("LinearSpeed", Range( 0 , 0.4)) = 0.4
		_BLABLA("BLABLA", Range( 1 , 2)) = 1

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		GrabPass{ }

		Pass
		{
		CGPROGRAM
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _WaveFrequency;
			uniform float _LinearSpeed;
			uniform float _WaveSpeed;
			uniform float _WaveAmplitude;
			uniform float _BLABLA;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _FrequencyX;
			uniform float _TimeSpeed;
			uniform float _AmplitudeX;
			uniform float _FrequencyY;
			uniform float _AmplitudeY;
			uniform float4 _WaterColor;
			uniform float4 _FoamColor;
			uniform float _FoamRadius;
			uniform float2 _Player;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float4 ase_clipPos = UnityObjectToClipPos(IN.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				OUT.ase_texcoord1 = screenPos;
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 texCoord61 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float TextureCoordinates_Vy63 = texCoord61.y;
				float TextureCoordinates_Ux62 = texCoord61.x;
				float mulTime9 = _Time.y * _LinearSpeed;
				float WaveMovement22 = step( TextureCoordinates_Vy63 , ( ( sin( ( ( ( TextureCoordinates_Ux62 * _WaveFrequency ) + mulTime9 ) * ( _WaveSpeed * 6.28318548202515 ) ) ) * _WaveAmplitude ) + _BLABLA ) );
				float temp_output_37_0 = ( _Time.y * _TimeSpeed );
				float4 screenPos = IN.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 appendResult78 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
				float4 ScreenPosition_XY79 = appendResult78;
				float4 screenColor45 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( sin( ( ( TextureCoordinates_Ux62 * _FrequencyX ) + temp_output_37_0 ) ) * _AmplitudeX ) + ScreenPosition_XY79 + ( sin( ( temp_output_37_0 + ( TextureCoordinates_Ux62 * _FrequencyY ) ) ) * _AmplitudeY ) ).xy);
				float4 WaterDistortion73 = screenColor45;
				float4 appendResult86 = (float4(TextureCoordinates_Ux62 , TextureCoordinates_Vy63 , 0.0 , 0.0));
				float smoothstepResult57 = smoothstep( 0.0 , _FoamRadius , length( ( appendResult86 - float4( _Player, 0.0 , 0.0 ) ) ));
				float4 lerpResult49 = lerp( _WaterColor , _FoamColor , ( 1.0 - pow( smoothstepResult57 , 2.53 ) ));
				float4 AlbedoRefraction81 = lerpResult49;
				
				fixed4 c = ( WaveMovement22 * ( WaterDistortion73 * AlbedoRefraction81 ) );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
235;73;1225;611;2278.949;635.4718;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;64;-2652.431,13.00455;Inherit;False;700.4873;539.8114;TextureCoordinates + Screen Position;6;63;62;61;78;79;76;TextureCoordinates + Screen Position;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-2547.431,77.51241;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2282.73,63.00455;Inherit;False;TextureCoordinates_Ux;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2277.917,157.7226;Inherit;False;TextureCoordinates_Vy;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-2155.408,773.7377;Inherit;False;1977.183;499.3687;Comment;14;60;59;58;57;56;53;55;81;49;48;47;86;84;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2142.642,836.821;Inherit;False;62;TextureCoordinates_Ux;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-2140.642,920.821;Inherit;False;63;TextureCoordinates_Vy;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2648.212,-651.8173;Inherit;False;1819.632;551.0703;;18;69;68;71;19;16;17;6;10;13;70;2;5;12;9;4;8;65;22;Wave Movement;0.6933962,0.9097468,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1918.823,-22.09823;Inherit;False;1744.537;749.4341;Water Distortion;22;73;45;29;43;41;39;26;80;44;40;42;38;25;37;33;32;24;36;35;66;67;75;Water Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1803.763,626.567;Inherit;False;Property;_FrequencyY;FrequencyY;7;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1841.133,367.5193;Inherit;False;Property;_TimeSpeed;TimeSpeed;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1812.36,102.522;Inherit;False;Property;_FrequencyX;FrequencyX;4;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1888.804,26.53437;Inherit;False;62;TextureCoordinates_Ux;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2630.704,-499.3026;Inherit;False;Property;_WaveFrequency;Wave Frequency;0;0;Create;True;0;0;0;False;0;False;2.42703;2.34;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1848.766,295.1844;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;53;-1917.211,994.8954;Inherit;False;Property;_Player;_Player;10;0;Create;True;0;0;0;False;0;False;0,0;0.55,0.41;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;4;-2631.25,-401.7008;Inherit;False;Property;_LinearSpeed;LinearSpeed;12;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2599.629,-583.0091;Inherit;False;62;TextureCoordinates_Ux;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;-1879.642,853.821;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1884.804,545.5344;Inherit;False;62;TextureCoordinates_Ux;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;76;-2588.169,322.8749;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1571.76,295.7828;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-2300.25,-397.7007;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1555.002,550.3931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;5;-2520.534,-220.193;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1569.143,32.35682;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2628.212,-303.3495;Inherit;False;Property;_WaveSpeed;Wave Speed;6;0;Create;True;0;0;0;False;0;False;0.931611;2.39;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-1648.164,854.4064;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2268.561,-505.6338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1347.132,145.3273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;56;-1492.329,854.7023;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1359.35,452.8024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1520.056,949.9784;Inherit;False;Property;_FoamRadius;FoamRadius;11;0;Create;True;0;0;0;False;0;False;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2146.58,-296.9519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-2347.397,352.5779;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-2113.647,-469.5343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;-1334.929,854.3215;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-2189.397,346.5779;Inherit;False;ScreenPosition_XY;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;39;-1219.707,453.6089;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1044.781,214.2305;Inherit;False;Property;_AmplitudeX;AmplitudeX;9;0;Create;True;0;0;0;False;0;False;0.02;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1970.039,-468.8864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;40;-1221.924,145.0966;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1063.038,522.7863;Inherit;False;Property;_AmplitudeY;AmplitudeY;8;0;Create;True;0;0;0;False;0;False;0.02;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;-1137.511,1179.065;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.53;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-863.9103,145.6976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-883.3279,456.1594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1969.018,-250.6195;Inherit;False;Property;_WaveAmplitude;Wave Amplitude;1;0;Create;True;0;0;0;False;0;False;0;0.73;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-981.1626,329.3492;Inherit;False;79;ScreenPosition_XY;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;17;-1813.646,-468.5342;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-663.7734,309.2879;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;47;-1055.674,830.5403;Inherit;False;Property;_WaterColor;_WaterColor;3;0;Create;True;0;0;0;False;0;False;0.2541118,0.7452364,0.7830189,0.7803922;0.2541117,0.7452364,0.7830188,0.7803922;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1590.133,-468.3461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-1042.77,1004.177;Inherit;False;Property;_FoamColor;FoamColor;5;0;Create;True;0;0;0;False;0;False;0.6735849,0.9758211,1,0.7803922;0,0.8605688,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-1635.935,-362.3405;Inherit;False;Property;_BLABLA;BLABLA;13;0;Create;True;0;0;0;False;0;False;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;60;-829.1271,1179.468;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1377.935,-469.3404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-565.6671,985.8093;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;45;-546.2233,304.6506;Inherit;False;Global;_GrabScreen0;Grab Screen 0;8;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1492.222,-551.0594;Inherit;False;63;TextureCoordinates_Vy;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-376.209,303.9454;Inherit;False;WaterDistortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;68;-1159.229,-492.1098;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-394.3368,981.1987;Inherit;False;AlbedoRefraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-700.759,-300.097;Inherit;False;73;WaterDistortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1036.951,-498.6638;Inherit;False;WaveMovement;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-706.4761,-221.5469;Inherit;False;81;AlbedoRefraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-488.7416,-293.882;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-553.9131,-401.7607;Inherit;False;22;WaveMovement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;75;-946.48,588.7701;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-305.4012,-356.2916;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-167.1691,-356.4943;Float;False;True;-1;2;ASEMaterialInspector;0;8;Water_Shader;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;62;0;61;1
WireConnection;63;0;61;2
WireConnection;86;0;84;0
WireConnection;86;1;85;0
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;9;0;4;0
WireConnection;25;0;67;0
WireConnection;25;1;24;0
WireConnection;33;0;66;0
WireConnection;33;1;32;0
WireConnection;55;0;86;0
WireConnection;55;1;53;0
WireConnection;12;0;65;0
WireConnection;12;1;8;0
WireConnection;38;0;33;0
WireConnection;38;1;37;0
WireConnection;56;0;55;0
WireConnection;26;0;37;0
WireConnection;26;1;25;0
WireConnection;6;0;2;0
WireConnection;6;1;5;0
WireConnection;78;0;76;1
WireConnection;78;1;76;2
WireConnection;13;0;12;0
WireConnection;13;1;9;0
WireConnection;57;0;56;0
WireConnection;57;2;58;0
WireConnection;79;0;78;0
WireConnection;39;0;26;0
WireConnection;10;0;13;0
WireConnection;10;1;6;0
WireConnection;40;0;38;0
WireConnection;59;0;57;0
WireConnection;44;0;40;0
WireConnection;44;1;42;0
WireConnection;43;0;39;0
WireConnection;43;1;41;0
WireConnection;17;0;10;0
WireConnection;29;0;44;0
WireConnection;29;1;80;0
WireConnection;29;2;43;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;60;0;59;0
WireConnection;70;0;19;0
WireConnection;70;1;71;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;49;2;60;0
WireConnection;45;0;29;0
WireConnection;73;0;45;0
WireConnection;68;0;69;0
WireConnection;68;1;70;0
WireConnection;81;0;49;0
WireConnection;22;0;68;0
WireConnection;51;0;74;0
WireConnection;51;1;82;0
WireConnection;52;0;72;0
WireConnection;52;1;51;0
WireConnection;0;0;52;0
ASEEND*/
//CHKSM=5C5E5F4CCF7FA6642C5A0019F0FA4ECAF9EADF81