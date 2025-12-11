using Unity.Mathematics;
using UnityEditor;
using UnityEngine;

namespace BlueOyster.Dynamics
{
    [CustomEditor(typeof(DynamicsPresetSO))]
    public class DynamicsPresetSOEditor : Editor
    {
        private const float defaultLenght = 2.0f;
        private const float defaultValue = 1.0f;

        private const float paddingLeft = 10f;
        private const float paddingRight = 2f;
        private const float paddingTop = 15f;
        private const float paddingBottom = 15f;

        private const int evaluationSteps = 300;

        private float f,
            f0,
            z,
            z0,
            r,
            r0;

        private Dynamics3 func;

        private Material mat;

        private EvaluationData evalData;

        private void OnEnable()
        {
            var shader = Shader.Find("Hidden/Internal-Colored");
            mat = new Material(shader);

            evalData = new();

            InitFunction();
        }

        private void OnDisable()
        {
            func = null;
            evalData = null;

            f = f0 = z = z0 = r = r0 = float.NaN;

            DestroyImmediate(mat);
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            EditorGUILayout.LabelField("Dynamics Parameters", EditorStyles.boldLabel);

            var fprop = serializedObject.FindProperty("F");
            var zprop = serializedObject.FindProperty("Z");
            var rprop = serializedObject.FindProperty("R");

            EditorGUILayout.PropertyField(fprop);
            EditorGUILayout.PropertyField(zprop);
            EditorGUILayout.PropertyField(rprop);

            UpdateInput();

            Rect rect = GUILayoutUtility.GetRect(10, 1000, 200, 200);
            if (Event.current.type == EventType.Repaint)
            {
                GUI.BeginClip(rect);
                GL.PushMatrix();

                GL.Clear(true, false, Color.black);
                mat.SetPass(0);

                float rectWidth = rect.width - paddingLeft - paddingRight;
                float rectHeight = rect.height - paddingTop - paddingBottom;

                float x_AxisOffset =
                    rectHeight * math.remap(evalData.Y_min, evalData.Y_max, 0, 1, 0);
                float defaultValueOffset =
                    rectHeight * math.remap(evalData.Y_min, evalData.Y_max, 0, 1, 1);
                ;

                // draw base graph
                GL.Begin(GL.LINES);
                GL.Color(new Color(1, 1, 1, 1));
                // draw Y axis
                GL.Vertex3(paddingLeft, paddingTop, 0);
                GL.Vertex3(paddingLeft, rect.height - paddingBottom, 0);
                // draw X axis
                GL.Vertex3(paddingLeft, rect.height - x_AxisOffset - paddingBottom, 0);
                GL.Vertex3(
                    rect.width - paddingRight,
                    rect.height - x_AxisOffset - paddingBottom,
                    0
                );
                // draw default values
                GL.Color(Color.green);
                GL.Vertex3(paddingLeft, rect.height - defaultValueOffset - paddingBottom, 0);
                GL.Vertex3(
                    rect.width - paddingRight,
                    rect.height - defaultValueOffset - paddingBottom,
                    0
                );
                GL.End();

                // evaluate func values
                if (evalData.IsEmpty)
                    EvaluateFunction();

                // re-evaluate func values after input values changed
                if (f != f0 || z != z0 || r != r0)
                {
                    InitFunction();
                    EvaluateFunction();
                }

                // draw graph
                GL.Begin(GL.LINE_STRIP);
                GL.Color(Color.cyan);
                for (int i = 0; i < evalData.Length; i++)
                {
                    Vector2 point = evalData.GetItem(i);

                    float x_remap = math.remap(
                        evalData.X_min,
                        evalData.X_max,
                        0,
                        rectWidth,
                        point.x
                    );
                    float y_remap = math.remap(
                        evalData.Y_min,
                        evalData.Y_max,
                        0,
                        rectHeight,
                        point.y
                    );

                    GL.Vertex3(paddingLeft + x_remap, rect.height - y_remap - paddingBottom, 0.0f);
                }
                GL.End();

                GL.PopMatrix();
                GUI.EndClip();

                // draw values
                float squareSize = 10;
                EditorGUI.LabelField(
                    new Rect(
                        rect.x + paddingLeft - squareSize,
                        rect.y + rect.height - defaultValueOffset - paddingBottom - squareSize / 2,
                        squareSize,
                        squareSize
                    ),
                    "1"
                ); // heigt "1" mark
                EditorGUI.LabelField(
                    new Rect(
                        rect.x + paddingLeft - squareSize,
                        rect.y + rect.height - x_AxisOffset - paddingBottom + (squareSize * 0.2f),
                        squareSize,
                        squareSize
                    ),
                    "0"
                ); // height "0" mark
                EditorGUI.LabelField(
                    new Rect(
                        rect.x + rect.width - paddingRight - squareSize,
                        rect.y + rect.height - x_AxisOffset - paddingBottom + (squareSize * 0.2f),
                        squareSize,
                        squareSize
                    ),
                    "2"
                ); // max lenght mark
            }

            serializedObject.ApplyModifiedProperties();
        }

        private void UpdateInput()
        {
            f = ((DynamicsPresetSO)target).F;
            z = ((DynamicsPresetSO)target).Z;
            r = ((DynamicsPresetSO)target).R;
        }

        private void InitFunction()
        {
            f0 = f = ((DynamicsPresetSO)target).F;
            z0 = z = ((DynamicsPresetSO)target).Z;
            r0 = r = ((DynamicsPresetSO)target).R;

            func = new Dynamics3(f, z, r, new Vector3(-defaultLenght, 0, 0));
        }

        private void EvaluateFunction()
        {
            evalData.Clear();

            for (int i = 0; i < evaluationSteps; i++)
            {
                float T = 0.016f; // constant deltaTime (60 frames per second)

                // input step function params
                float x_input = math.remap(
                    0,
                    evaluationSteps - 1,
                    -defaultLenght,
                    defaultLenght,
                    i
                );
                float y_input = x_input > 0 ? defaultValue : 0;

                Vector3? funcValues = func.Update(T, new Vector3(x_input, y_input, 0));

                if (x_input <= 0)
                    continue; // data is gathered only after the Y value has changed

                evalData.Add(new Vector2(funcValues.Value.x, funcValues.Value.y));
            }
        }
    }
}
