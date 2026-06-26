// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ProyectorPersiana"
{
	Properties
	{
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
			half filler;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;83.2;980.6;740.2;1504.747;-558.6708;2.342505;True;False
Node;AmplifyShaderEditor.CommentaryNode;81;-912.6839,842.9508;Inherit;False;1790.363;497.5571;Comment;8;75;76;77;72;73;74;78;79;Mañana -> Tarde;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;80;-921.1273,311.7172;Inherit;False;1880.273;463.8538;Comment;8;65;62;68;70;21;71;64;18;Noche -> Mañana;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;87.92345,-796.2917;Inherit;False;X_Cos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-283.4157,-861.4417;Inherit;False;30;CosAngle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-284.9778,-650.5159;Inherit;False;33;SinAngle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1187.846,-1046.4;Inherit;False;Property;_TimeOfDay;TimeOfDay;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-263.7332,380.38;Inherit;False;NightToMorning;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-497.3933,371.8267;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;68;517.1406,436.5988;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;734.3454,436.6555;Inherit;False;Color1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-38.46543,380.1591;Inherit;False;Constant;_NightColor;NightColor;4;0;Create;True;0;0;0;False;0;False;0.009077946,0.01211622,0.2830189,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;264.4872,625.0771;Inherit;False;65;NightToMorning;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-871.1273,361.7172;Inherit;False;Property;_TimeOfDay1;TimeOfDay;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-28.63847,566.571;Inherit;False;Constant;_MorningColor;MorningColor;4;0;Create;True;0;0;0;False;0;False;1,0.3556145,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;75;458.3431,1064.534;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;652.8792,1021.501;Inherit;False;Color2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;212.5605,1225.108;Inherit;False;74;MorningToNoon;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;72;-551.0497,923.9422;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-311.2738,919.6654;Inherit;False;MorningToNoon;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-24.24914,1080.268;Inherit;False;Constant;_MorningColor1;MorningColor;4;0;Create;True;0;0;0;False;0;False;1,0.3556145,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-862.6839,916.9939;Inherit;False;Property;_TimeOfDay2;TimeOfDay;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-963.7784,1417.757;Inherit;False;Property;_TimeOfDay3;TimeOfDay;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-356.0042,1468.574;Inherit;False;NoonToEvening;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1378.935,757.7314;Inherit;False;Constant;_MidDayColor;MidDayColor;4;0;Create;True;0;0;0;False;0;False;1,0.838609,0.7490566,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;82;-603.9924,1419.79;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-1443.494,1125.05;Inherit;False;Constant;_EveningColor;EveningColor;4;0;Create;True;0;0;0;False;0;False;0.4746473,0.4115343,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;79;-25.73962,892.9508;Inherit;False;Constant;_MidDayColor1;MidDayColor;4;0;Create;True;0;0;0;False;0;False;1,0.838609,0.7490566,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;88;318.1429,1645.24;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;561.501,1622.862;Inherit;False;Color3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;86;-197.8548,1735.44;Inherit;False;Constant;_EveningColor1;EveningColor;4;0;Create;True;0;0;0;False;0;False;0.4746473,0.4115343,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-59.1092,-798.4264;Inherit;False;2;2;0;OBJECT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;36;-281.535,-783.0324;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;37;-519.3953,-782.7026;Inherit;False;35;WorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-935.1086,-643.3156;Inherit;False;WorldPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;91.75561,-696.8982;Inherit;False;Y_Sin;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-353.9657,-388.9338;Inherit;False;45;Y_Sin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-158.0846,-428.6779;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;16.60259,-423.2893;Inherit;False;RotatedX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1150.079,-266.1245;Inherit;False;49;RotatedX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-861.7269,-235.1443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1226.271,-166.431;Inherit;False;Property;_BlindsDensity;BlindsDensity;4;0;Create;True;0;0;0;False;0;False;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-702.2343,-243.5722;Inherit;False;RotatedDense;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-445.2275,-225.5287;Inherit;False;53;RotatedDense;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;55;-146.8432,-222.5146;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;36.0071,-229.1751;Inherit;False;FracPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;58;-840.822,34.22798;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1093.812,-19.98427;Inherit;False;56;FracPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1190.522,96.49393;Inherit;False;Property;_BlindsSoftness;BlindsSoftness;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;-193.2745,1543.443;Inherit;False;Constant;_MidDayColor2;MidDayColor;4;0;Create;True;0;0;0;False;0;False;1,0.838609,0.7490566,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-686.4609,28.17653;Inherit;False;BlindsPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-353.9657,-491.1326;Inherit;False;42;X_Cos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-1572.663,327.5341;Inherit;False;Constant;_ProjectorScale;ProjectorScale;2;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-58.19837,-694.7501;Inherit;False;2;2;0;FLOAT;0;False;1;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-769.515,-1044.258;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6.28318;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;23;-901.3942,-960.4603;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-597.5948,-1018.199;Inherit;False;AngleRadians;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1175.033,-865.8885;Inherit;False;27;AngleRadians;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;29;-950.7534,-857.52;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-810.1591,-864.2148;Inherit;False;CosAngle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1179.687,-755.1413;Inherit;False;30;CosAngle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;32;-951.2932,-744.2654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-798.6635,-751.4435;Inherit;False;SinAngle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;34;-1171.781,-634.0344;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-1379.265,510.6281;Inherit;False;Property;_LightIntensityMult;LightIntensityMult;5;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;90.16033,1801.866;Inherit;False;84;NoonToEvening;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;373.6077,-496.1955;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ProyectorPersiana;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;40;0
WireConnection;65;0;62;0
WireConnection;62;0;64;0
WireConnection;68;0;21;0
WireConnection;68;1;18;0
WireConnection;68;2;71;0
WireConnection;70;0;68;0
WireConnection;75;0;79;0
WireConnection;75;1;78;0
WireConnection;75;2;77;0
WireConnection;76;0;75;0
WireConnection;72;0;73;0
WireConnection;74;0;72;0
WireConnection;84;0;82;0
WireConnection;82;0;83;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;88;2;90;0
WireConnection;89;0;88;0
WireConnection;40;0;41;0
WireConnection;40;1;36;0
WireConnection;36;0;37;0
WireConnection;35;0;34;0
WireConnection;45;0;43;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;49;0;48;0
WireConnection;52;0;51;0
WireConnection;52;1;2;0
WireConnection;53;0;52;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;58;0;57;0
WireConnection;58;1;3;0
WireConnection;59;0;58;0
WireConnection;43;0;36;1
WireConnection;43;1;44;0
WireConnection;22;0;1;0
WireConnection;22;1;23;0
WireConnection;27;0;22;0
WireConnection;29;0;28;0
WireConnection;30;0;29;0
WireConnection;32;0;31;0
WireConnection;33;0;32;0
ASEEND*/
//CHKSM=24E3CAEE3BA2994F024EA996B84EEBCBFDD38054