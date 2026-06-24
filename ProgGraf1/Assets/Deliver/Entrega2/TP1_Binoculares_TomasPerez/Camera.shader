// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Camera"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Overlay("Overlay", 2D) = "white" {}
		_FishEyePower("FishEyePower", Range( 0 , 2)) = 0
		_GrainIntensity("Grain Intensity", Range( 0 , 1.5)) = 0
		_Radius("Radius", Range( 0 , 1)) = 0
		_GrainyScale("GrainyScale", Range( 100 , 400)) = 300
		_FadeStart("FadeStart", Range( 0.001 , 1)) = 0.001
		_FadeEnd("FadeEnd", Range( 0 , 1)) = 0.1
		_GraintContrast("GraintContrast", Range( 0 , 1)) = 0.5
		_TimeSpeed("Time Speed", Range( 1 , 5)) = 3
		_PixelGrid("PixelGrid", Float) = 512

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Radius;
			uniform float _FishEyePower;
			uniform float _PixelGrid;
			uniform float _FadeStart;
			uniform float _FadeEnd;
			uniform float _TimeSpeed;
			uniform float _GrainyScale;
			uniform float _GraintContrast;
			uniform float _GrainIntensity;
			uniform sampler2D _Overlay;
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
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 color53 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 ScreenCenter9 = ( (ase_screenPosNorm).xy - float2( 0.5,0.5 ) );
				float2 break12 = ScreenCenter9;
				float4 appendResult15 = (float4(( break12.x * ( _ScreenParams.x / _ScreenParams.y ) ) , break12.y , 0.0 , 0.0));
				float ScreenLength17 = length( appendResult15 );
				float clampResult24 = clamp( ( ScreenLength17 / _Radius ) , 0.0 , 1.0 );
				float2 FishEye29 = ( ( ( pow( clampResult24 , _FishEyePower ) * 0.5 ) * ScreenCenter9 ) + 0.5 );
				float pixelWidth81 =  1.0f / _PixelGrid;
				float pixelHeight81 = 1.0f / _PixelGrid;
				half2 pixelateduv81 = half2((int)(FishEye29.x / pixelWidth81) * pixelWidth81, (int)(FishEye29.y / pixelHeight81) * pixelHeight81);
				float smoothstepResult57 = smoothstep( _FadeStart , _FadeEnd , ScreenLength17);
				float4 lerpResult61 = lerp( color53 , tex2D( _MainTex, pixelateduv81 ) , smoothstepResult57);
				float temp_output_38_0 = ( _Time.y * _TimeSpeed );
				float2 texCoord1 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 GrainyUV4 = ( texCoord1 * _GrainyScale );
				float2 panner42 = ( temp_output_38_0 * float2( 2,-0.1 ) + GrainyUV4);
				float simplePerlin2D44 = snoise( panner42 );
				simplePerlin2D44 = simplePerlin2D44*0.5 + 0.5;
				float2 panner43 = ( temp_output_38_0 * float2( -0.6,0.05 ) + GrainyUV4);
				float simplePerlin2D45 = snoise( panner43 );
				simplePerlin2D45 = simplePerlin2D45*0.5 + 0.5;
				float GrainNoise52 = ( ( (0.0 + (( simplePerlin2D44 * simplePerlin2D45 ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) - _GraintContrast ) * _GrainIntensity );
				float4 CameraView64 = ( lerpResult61 + GrainNoise52 );
				float2 texCoord31 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode32 = tex2D( _Overlay, texCoord31 );
				float4 appendResult34 = (float4(tex2DNode32.r , tex2DNode32.g , tex2DNode32.b , 0.0));
				float4 OverlayTexture35 = appendResult34;
				float OverlayAlpha33 = tex2DNode32.a;
				float4 lerpResult65 = lerp( CameraView64 , OverlayTexture35 , OverlayAlpha33);
				

				finalColor = lerpResult65;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
246;73;1404;665;2237.976;869.2334;1.792075;True;False
Node;AmplifyShaderEditor.CommentaryNode;71;-1385.706,-276.6576;Inherit;False;868.86;318.2205;Screen Center;5;5;6;7;8;9;Screen Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;5;-1335.706,-226.5269;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-1102.847,-122.4371;Inherit;False;Constant;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1119.973,-226.6576;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-887.8461,-189.4371;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-740.8459,-195.4372;Inherit;False;ScreenCenter;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;72;-429.5872,-294.8173;Inherit;False;1160.397;339.2614;Center Length;8;10;11;13;12;14;15;16;17;Center Length;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenParams;10;-370.7939,-162.5559;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;11;-379.5872,-244.8173;Inherit;False;9;ScreenCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;13;-123.7087,-138.1749;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-123.2264,-238.9371;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;55.38924,-238.7593;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;237.487,-239.4904;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;16;383.925,-239.6882;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-2156.812,-708.5994;Inherit;False;1599.192;374.2295;Fish Eye;13;19;18;23;24;22;21;25;69;26;20;27;28;29;Fish Eye;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2166.106,-274.8112;Inherit;False;717.0621;297.3978;Grain UV;4;2;1;3;4;Grain UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;506.8094,-244.2771;Inherit;False;ScreenLength;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2061.001,-658.5994;Inherit;False;17;ScreenLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2058.073,-224.8112;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-2116.106,-93.41346;Inherit;False;Property;_GrainyScale;GrainyScale;4;0;Create;True;0;0;0;False;0;False;300;0;100;400;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2106.813,-575.1453;Inherit;False;Property;_Radius;Radius;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-2210.715,76.07774;Inherit;False;2158.15;584.8855;Grain Noise;17;37;36;40;41;39;38;43;42;45;44;46;47;50;51;48;49;52;Grain Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1816.095,-164.1766;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-1816.167,-653.234;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1801.441,-528.3546;Inherit;False;Property;_FishEyePower;FishEyePower;1;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;24;-1672.621,-652.5555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-2058.874,260.4748;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1673.044,-169.069;Inherit;False;GrainyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2160.715,344.2227;Inherit;False;Property;_TimeSpeed;Time Speed;8;0;Create;True;0;0;0;False;0;False;3;0;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1873.598,281.2486;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-1504.621,-652.5555;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1629.667,-450.3704;Inherit;False;Constant;_FishEyeZoom;FishEyeZoom;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;41;-1871.695,422.4363;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;-0.6,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;39;-1682.02,299.0362;Inherit;False;4;GrainyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;40;-1879.155,150.0778;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;2,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;43;-1411.665,404.1093;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;42;-1412.894,130.5202;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1317.258,-541.156;Inherit;False;9;ScreenCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1318.621,-652.5555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;44;-1232.361,126.0777;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1103.621,-652.5555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1101.175,-544.3597;Inherit;False;Constant;_FishEyeCenter;FishEyeCenter;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;-1228.343,399.0203;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-939.7205,292.2663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-904.6216,-652.5555;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-895.566,468.9632;Inherit;False;Property;_GraintContrast;GraintContrast;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-797.8337,292.9034;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-781.6216,-657.5555;Inherit;False;FishEye;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;76;-20.6818,84.03813;Inherit;False;1463.746;683.1302;Assemble Effects;14;64;62;63;61;55;57;53;60;59;58;54;81;78;79;Fish Eye + Grain + Camera + Pixel;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;11.94387,409.1369;Inherit;False;Property;_PixelGrid;PixelGrid;9;0;Create;True;0;0;0;False;0;False;512;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-564.3179,292.576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-804.566,546.963;Inherit;False;Property;_GrainIntensity;Grain Intensity;2;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2.417816,326.9367;Inherit;False;29;FishEye;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-410.1039,293.1335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-502.3259,-694.5731;Inherit;False;971.64;334.1968;Overlay;5;31;32;34;35;33;Overlay;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCPixelate;81;210.944,366.1371;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;322.5116,508.1759;Inherit;False;17;ScreenLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;245.5115,584.1759;Inherit;False;Property;_FadeStart;FadeStart;5;0;Create;True;0;0;0;False;0;False;0.001;0;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;248.5115,668.1759;Inherit;False;Property;_FadeEnd;FadeEnd;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;54;267.2521,286.6666;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-276.5659,287.9633;Inherit;False;GrainNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;447.5118,306.1764;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;57;574.5116,566.1759;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;530.2057,133.8628;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-452.3259,-615.39;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;63;851.6053,411.6092;Inherit;False;52;GrainNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;871.1565,287.5429;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;32;-235.069,-644.5731;Inherit;True;Property;_Overlay;Overlay;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;1095.843,287.3134;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;99.87862,-616.1629;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;242.3141,-621.2479;Inherit;False;OverlayTexture;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;1244.021,282.3133;Inherit;False;CameraView;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;100.1713,-476.3767;Inherit;False;OverlayAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;777.0836,-39.21027;Inherit;False;33;OverlayAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;784.0836,-196.2103;Inherit;False;64;CameraView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;768.0836,-114.2103;Inherit;False;35;OverlayTexture;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;65;1009.084,-133.2103;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1172.999,-133.2847;Float;False;True;-1;2;ASEMaterialInspector;0;4;Camera;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;13;0;10;1
WireConnection;13;1;10;2
WireConnection;12;0;11;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;15;0;14;0
WireConnection;15;1;12;1
WireConnection;16;0;15;0
WireConnection;17;0;16;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;23;0;18;0
WireConnection;23;1;19;0
WireConnection;24;0;23;0
WireConnection;4;0;3;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;25;0;24;0
WireConnection;25;1;22;0
WireConnection;43;0;39;0
WireConnection;43;2;41;0
WireConnection;43;1;38;0
WireConnection;42;0;39;0
WireConnection;42;2;40;0
WireConnection;42;1;38;0
WireConnection;26;0;25;0
WireConnection;26;1;21;0
WireConnection;44;0;42;0
WireConnection;27;0;26;0
WireConnection;27;1;69;0
WireConnection;45;0;43;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;28;0;27;0
WireConnection;28;1;20;0
WireConnection;47;0;46;0
WireConnection;29;0;28;0
WireConnection;48;0;47;0
WireConnection;48;1;50;0
WireConnection;49;0;48;0
WireConnection;49;1;51;0
WireConnection;81;0;78;0
WireConnection;81;1;79;0
WireConnection;81;2;79;0
WireConnection;52;0;49;0
WireConnection;55;0;54;0
WireConnection;55;1;81;0
WireConnection;57;0;58;0
WireConnection;57;1;59;0
WireConnection;57;2;60;0
WireConnection;61;0;53;0
WireConnection;61;1;55;0
WireConnection;61;2;57;0
WireConnection;32;1;31;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;34;0;32;1
WireConnection;34;1;32;2
WireConnection;34;2;32;3
WireConnection;35;0;34;0
WireConnection;64;0;62;0
WireConnection;33;0;32;4
WireConnection;65;0;66;0
WireConnection;65;1;67;0
WireConnection;65;2;68;0
WireConnection;0;0;65;0
ASEEND*/
//CHKSM=EC32498901058D377ADAC612DD93B9E14C831644