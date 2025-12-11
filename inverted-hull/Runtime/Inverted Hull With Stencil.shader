Shader "Shader Graphs/Inverted Hull"
    {
        Properties
        {
                                                [IntRange] _StencilID ("Stencil ID", Range(0, 255)) = 0
            [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
            [HideInInspector]_QueueControl("_QueueControl", Float) = -1
            [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        }
        SubShader
        {
            Tags
            {
                "RenderPipeline"="UniversalPipeline"
                "RenderType"="Opaque"
                "UniversalMaterialType" = "Unlit"
                "Queue"="Geometry"
                "DisableBatching"="False"
                "ShaderGraphShader"="true"
                "ShaderGraphTargetId"="UniversalUnlitSubTarget"
            }
            Pass
            {
                Name "Universal Forward"
                Tags
                {
                    // LightMode: <None>
                }

                                                                Stencil
                {
                    Ref [_StencilID]
                    Comp NotEqual
                    Pass Keep
                    Fail Keep
                }
            
            // Render State
            Cull Front
                Blend One Zero
                ZTest LEqual
                ZWrite On
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma instancing_options renderinglayer
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
                #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
                #pragma shader_feature _ _SAMPLE_GI
                #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
                #define _FOG_FRAGMENT 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float3 normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS : INTERP0;
                     float3 normalWS : INTERP1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.positionWS.xyz = input.positionWS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.positionWS = input.positionWS.xyz;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Preview_float3(float3 In, out float3 Out)
                {
                    Out = In;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    Unity_Preview_float3(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3);
                    surface.BaseColor = _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }
            
            // Render State
            Cull Front
                ZTest LEqual
                ZWrite On
                ColorMask R
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "MotionVectors"
                Tags
                {
                    "LightMode" = "MotionVectors"
                }
            
            // Render State
            Cull Front
                ZTest LEqual
                ZWrite On
                ColorMask RG
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 3.5
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_MOTION_VECTORS
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "DepthNormalsOnly"
                Tags
                {
                    "LightMode" = "DepthNormalsOnly"
                }
            
            // Render State
            Cull Front
                ZTest LEqual
                ZWrite On
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "GBuffer"
                Tags
                {
                    "LightMode" = "UniversalGBuffer"
                }
            
            // Render State
            Cull Front
                Blend One Zero
                ZTest LEqual
                ZWrite On
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 4.5
                #pragma exclude_renderers gles3 glcore
                #pragma multi_compile_instancing
                #pragma instancing_options renderinglayer
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
                #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
                #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
                #pragma multi_compile _ SHADOWS_SHADOWMASK
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float3 normalWS;
                    #if !defined(LIGHTMAP_ON)
                     float3 sh;
                    #endif
                    #if defined(USE_APV_PROBE_OCCLUSION)
                     float4 probeOcclusion;
                    #endif
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if !defined(LIGHTMAP_ON)
                     float3 sh : INTERP0;
                    #endif
                    #if defined(USE_APV_PROBE_OCCLUSION)
                     float4 probeOcclusion : INTERP1;
                    #endif
                     float3 positionWS : INTERP2;
                     float3 normalWS : INTERP3;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(USE_APV_PROBE_OCCLUSION)
                    output.probeOcclusion = input.probeOcclusion;
                    #endif
                    output.positionWS.xyz = input.positionWS;
                    output.normalWS.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if !defined(LIGHTMAP_ON)
                    output.sh = input.sh;
                    #endif
                    #if defined(USE_APV_PROBE_OCCLUSION)
                    output.probeOcclusion = input.probeOcclusion;
                    #endif
                    output.positionWS = input.positionWS.xyz;
                    output.normalWS = input.normalWS.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Preview_float3(float3 In, out float3 Out)
                {
                    Out = In;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    Unity_Preview_float3(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3);
                    surface.BaseColor = _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "SceneSelectionPass"
                Tags
                {
                    "LightMode" = "SceneSelectionPass"
                }
            
            // Render State
            Cull Off
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENESELECTIONPASS 1
                #define ALPHA_CLIP_THRESHOLD 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
            Pass
            {
                Name "ScenePickingPass"
                Tags
                {
                    "LightMode" = "Picking"
                }
            
            // Render State
            Cull Front
            
            // Debug
            // <None>
            
            // --------------------------------------------------
            // Pass
            
            HLSLPROGRAM
            
            // Pragmas
            #pragma target 2.0
                #pragma vertex vert
                #pragma fragment frag
            
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENEPICKINGPASS 1
                #define ALPHA_CLIP_THRESHOLD 1
            
            
            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
            // --------------------------------------------------
            // Structs and Packing
            
            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
            struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                     float3 WorldSpacePosition;
                     float4 uv1;
                     float3 TimeParameters;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
            PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
                UNITY_TEXTURE_STREAMING_DEBUG_VARS;
                CBUFFER_END
                
                
                // Object and Global properties
            
            // Graph Includes
            #include_with_pragmas "Assets/Shaders/HLSL/globals.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
            
            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            
            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif
            
            // Graph Functions
            
                struct Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float
                {
                };
                
                void SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float IN, out float3 LightHighlightColor_1, out float OutlineThickness_2, out float WorldSpaceWobbleAmount_3, out float WorldSpaceNoiseScale_4, out float WorldSpaceWobbleTimeInterval_5, out float WorldSpaceWobbleSpeed_6)
                {
                float3 _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                float _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                GetShaderGlobals_float(_GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float, _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float);
                LightHighlightColor_1 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_LightHighlightColor_0_Vector3;
                OutlineThickness_2 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_OutlineThickness_1_Float;
                WorldSpaceWobbleAmount_3 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleAmount_2_Float;
                WorldSpaceNoiseScale_4 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceNoiseScale_3_Float;
                WorldSpaceWobbleTimeInterval_5 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleTimeInterval_4_Float;
                WorldSpaceWobbleSpeed_6 = _GetShaderGlobalsCustomFunction_dfc5b111161f4575b9ec6b8a78913a9f_WorldSpaceWobbleSpeed_5_Float;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Floor_float(float In, out float Out)
                {
                    Out = floor(In);
                }
                
                void Unity_Multiply_float_float(float A, float B, out float Out)
                {
                Out = A * B;
                }
                
                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }
                
                float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
                {
                float x; Hash_Tchou_2_1_float(p, x);
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
                {
                float2 p = UV * Scale.xy;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }
                
                void Unity_Saturate_float(float In, out float Out)
                {
                    Out = saturate(In);
                }
                
                void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                {
                    Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                }
                
                void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                {
                Out = A * B;
                }
                
                struct Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float
                {
                half4 uv1;
                float3 TimeParameters;
                };
                
                void SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(float3 _World_Pos, Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float IN, out float3 World_Pos_1)
                {
                float3 _Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3 = _World_Pos;
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614;
                half3 _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_daa213b7e0fc4f58ba421881db58c614, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_LightHighlightColor_1_Vector3, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_OutlineThickness_2_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleSpeed_6_Float);
                float _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float;
                Unity_Divide_float(IN.TimeParameters.x, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float);
                float _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float;
                Unity_Floor_float(_Divide_c0b8e673399047408f0af88ce28ab488_Out_2_Float, _Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float);
                float _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float;
                Unity_Multiply_float_float(_Floor_dd969210c6174a848b28edf98ddf709b_Out_1_Float, _ShaderGlobals_daa213b7e0fc4f58ba421881db58c614_WorldSpaceWobbleTimeInterval_5_Float, _Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4;
                half3 _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_LightHighlightColor_1_Vector3, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_OutlineThickness_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float);
                float _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float;
                Unity_Multiply_float_float(_Multiply_66c96903cb324ddfa060ba3e26d53714_Out_2_Float, _ShaderGlobals_4eced0552ab14304ab61c5c65c55fbe4_WorldSpaceWobbleSpeed_6_Float, _Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float);
                float3 _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3 = _World_Pos;
                float3 _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3;
                Unity_Add_float3((_Multiply_00e43374cd71420ea3896309588c979d_Out_2_Float.xxx), _Property_e291c84bb8544c26957969009a92b86d_Out_0_Vector3, _Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3);
                Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6;
                half3 _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float;
                half _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float;
                SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_LightHighlightColor_1_Vector3, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_OutlineThickness_2_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleSpeed_6_Float);
                float _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float;
                Unity_GradientNoise_Deterministic_float((_Add_7013d3a2fb014b3886a717cd9404efe9_Out_2_Vector3.xy), _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceNoiseScale_4_Float, _GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float);
                float _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float;
                Unity_Saturate_float(_GradientNoise_e097e7b108fb442f9820fe228284c1db_Out_2_Float, _Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float);
                float _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float;
                Unity_Remap_float(_Saturate_36af4f29673545f2935fcb4509050aa4_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float);
                float _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float;
                Unity_Multiply_float_float(_Remap_cfc0e458bea24bc3b1614ef8d1d5bd5d_Out_3_Float, _ShaderGlobals_4726a647941a4fffb6c1bfca66d577b6_WorldSpaceWobbleAmount_3_Float, _Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float);
                float4 _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4 = IN.uv1;
                float4 _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4;
                Unity_Multiply_float4_float4((_Multiply_3197b22b27214641a8fa4ea455118efa_Out_2_Float.xxxx), _UV_4701088257554a46a425246cdd0859cb_Out_0_Vector4, _Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4);
                float3 _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                Unity_Add_float3(_Property_6ad4954805634b4a987bac2b7180df65_Out_0_Vector3, (_Multiply_01c17fa229c04ff582d3ce3bb11d0419_Out_2_Vector4.xyz), _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3);
                World_Pos_1 = _Add_9fb11f627a2e480cb8ad7a5f11d641cc_Out_2_Vector3;
                }
                
                void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Preview_float3(float3 In, out float3 Out)
                {
                    Out = In;
                }
            
            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
            // Graph Vertex
            struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    Bindings_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float _WorldSpaceWobble_f555b3329b104de0928fc70aac141348;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.uv1 = IN.uv1;
                    _WorldSpaceWobble_f555b3329b104de0928fc70aac141348.TimeParameters = IN.TimeParameters;
                    float3 _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3;
                    SG_WorldSpaceWobble_5eff1e013bba14f68ab1ba42f0608e80_float(IN.WorldSpacePosition, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348, _WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3);
                    float3 _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3;
                    _Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3 = TransformWorldToObject(_WorldSpaceWobble_f555b3329b104de0928fc70aac141348_WorldPos_1_Vector3.xyz);
                    float4 _UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4 = IN.uv1;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3;
                    Unity_Divide_float3((_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float.xxx), float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                             length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                             length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3);
                    float3 _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3;
                    Unity_Multiply_float3_float3((_UV_416685a730ed4cc3a7c938aad00639dc_Out_0_Vector4.xyz), _Divide_79456bf748914cf3b71ec69be8633bc5_Out_2_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3);
                    float3 _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    Unity_Add_float3(_Transform_3cf668b874f547f0ae840eae52b928f3_Out_1_Vector3, _Multiply_e30002eeb5ca4bfc9ea1b7fff239f4d8_Out_2_Vector3, _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3);
                    description.Position = _Add_11bba0a338454534b16e53d76f829cfc_Out_2_Vector3;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
                {
                    float3 BaseColor;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    Bindings_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c;
                    float3 _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float;
                    float _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float;
                    SG_ShaderGlobals_7c801057dd9034e079373d70ec254bad_float(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_OutlineThickness_2_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleAmount_3_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceNoiseScale_4_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleTimeInterval_5_Float, _ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_WorldSpaceWobbleSpeed_6_Float);
                    float3 _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    Unity_Preview_float3(_ShaderGlobals_0ff1d3990f4f44eba212a0f6c6dcfa8c_LightHighlightColor_1_Vector3, _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3);
                    surface.BaseColor = _Preview_eb9a08fb16444ccb8e4f2c8f220ea81a_Out_1_Vector3;
                    return surface;
                }
            
            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                    output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
                    output.uv1 =                                        input.uv1;
                    output.TimeParameters =                             _TimeParameters.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                
                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                #ifdef HAVE_VFX_MODIFICATION
                #if VFX_USE_GRAPH_VALUES
                    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
                    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
                #endif
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
                
                #endif
                
                    
                
                
                
                
                
                
                    #if UNITY_UV_STARTS_AT_TOP
                    #else
                    #endif
                
                
                #if UNITY_ANY_INSTANCING_ENABLED
                #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                        return output;
                }
                
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif
            
            ENDHLSL
            }
        }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
        FallBack "Hidden/Shader Graph/FallbackError"
    }