using System;
using UnityEditor;
using UnityEngine;

namespace BlueOyster.Reactive.PropertyDrawers
{
    [CustomPropertyDrawer(typeof(ReactiveDict<,>))]
    public class ReactiveDictPropertyDrawer : PropertyDrawer
    {
        private bool _rectsDebug = false;
        private bool _foldedOut = false;
        private float _removeButtonWidth = 60;
        private float _horizontalLineSpacing = EditorGUIUtility.standardVerticalSpacing;
        private float _buttonWidgetVertPadding = 10;
        private float _buttonWidgetHorzPadding = 10;

        private bool _keyInitted = false;
        private bool _valInitted = false;
        private object _keyVal = default(int);
        private object _valVal = default(string);

        private float GetDictionaryHeight(SerializedProperty property)
        {
            int numDictEls = GetValueProperty(property).arraySize;
            if (numDictEls == 0)
            {
                return EditorGUIUtility.standardVerticalSpacing + EditorGUIUtility.singleLineHeight;
            }

            return numDictEls
                * (EditorGUIUtility.standardVerticalSpacing + EditorGUIUtility.singleLineHeight);
        }

        private SerializedProperty GetValueProperty(SerializedProperty property) =>
            property.FindPropertyRelative("_kvps");

        // this hurts
        private void InitWidgetPart(ref bool initted, ref object val, Type type)
        {
            if (initted)
            {
                return;
            }
            initted = true;

            switch (type)
            {
                // not perfect but better than nothing
                case Type _ when type.IsSubclassOf(typeof(ScriptableObject)):
                    // val = ScriptableObject.CreateInstance(type.Name);
                    val = null;
                    return;

                // exception, because string is a ref type however
                // it does not have a new string() type construct
                case Type _ when type == typeof(string):
                    val = default(string);
                    return;

                default:
                    val = Activator.CreateInstance(type);
                    return;
            }
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            Type keyType = fieldInfo.FieldType.GenericTypeArguments[0];
            Type valType = fieldInfo.FieldType.GenericTypeArguments[1];
            InitWidgetPart(ref _keyInitted, ref _keyVal, keyType);
            InitWidgetPart(ref _valInitted, ref _valVal, valType);

            _foldedOut = EditorGUI.Foldout(
                new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                _foldedOut,
                new GUIContent(label.text + " [R]")
            );

            if (!_foldedOut)
            {
                return;
            }

            SerializedProperty kvps = GetValueProperty(property);
            int arraySize = kvps.arraySize;

            if (arraySize == 0)
            {
                EditorGUI.LabelField(WithLineOffset(position, 1), "(No Elements)");
                DrawAddKeyWidget(position, property, kvps, keyType, valType);
                return;
            }

            EditorGUI.BeginChangeCheck();
            var enumerator = kvps.GetEnumerator();
            int i = 1;
            while (enumerator.MoveNext())
            {
                var inner = enumerator.Current as SerializedProperty;

                Rect keyRect = WithLineOffset(position, i);
                Rect valRect = WithLineOffset(position, i);
                Rect removeRect = WithLineOffset(position, i);

                keyRect.width /= 2f;
                keyRect.width -= _removeButtonWidth / 2;
                keyRect.width -= _horizontalLineSpacing;

                valRect.width /= 2f;
                valRect.width -= _removeButtonWidth / 2;
                valRect.width -= _horizontalLineSpacing;
                valRect.x += valRect.width + _horizontalLineSpacing;

                removeRect.x += keyRect.width + valRect.width + (_horizontalLineSpacing * 2);
                removeRect.width = _removeButtonWidth;

                EditorGUI.PropertyField(
                    keyRect,
                    inner.FindPropertyRelative("Key"),
                    GUIContent.none
                );
                EditorGUI.PropertyField(
                    valRect,
                    inner.FindPropertyRelative("Val"),
                    GUIContent.none
                );

                if (GUI.Button(removeRect, "Remove"))
                {
                    int arrayIdx = i - 1;
                    kvps.DeleteArrayElementAtIndex(arrayIdx);
                }

                DrawRect(keyRect, Color.blue);
                DrawRect(valRect, Color.green);
                i++;
            }
            bool changed = EditorGUI.EndChangeCheck();

            if (changed)
            {
                property.serializedObject.ApplyModifiedProperties();
                ForceFlushCallbacks(property);
            }

            DrawAddKeyWidget(position, property, kvps, keyType, valType);
        }

        private void ForceFlushCallbacks(SerializedProperty property) { }

        private Rect WithLineOffset(Rect rect, int lines, float additionalSpacing = 0)
        {
            Rect r = new Rect(rect);
            r.y +=
                (EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing)
                * lines;
            r.y += additionalSpacing;
            r.height = EditorGUIUtility.singleLineHeight;
            return r;
        }

        private float GetAddKeyWidgetHeight()
        {
            float baseHeight =
                (EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing) * 2;
            return baseHeight + (_buttonWidgetVertPadding * 2);
        }

        private void DrawAddKeyWidget(
            Rect position,
            SerializedProperty property,
            SerializedProperty kvps,
            System.Type keyType,
            System.Type valType
        )
        {
            int numDictEls = GetValueProperty(property).arraySize;
            int linesFromTop = 1 + Mathf.Max(1, numDictEls); // 1 for the label, plus however many needed in dictionary with lower bound for empty text
            Rect keyInputRect = WithLineOffset(
                position,
                linesFromTop,
                additionalSpacing: _buttonWidgetVertPadding
            );
            Rect valInputRect = WithLineOffset(
                position,
                linesFromTop,
                additionalSpacing: _buttonWidgetVertPadding
            );
            Rect buttonRect = WithLineOffset(
                position,
                linesFromTop + 1,
                additionalSpacing: _buttonWidgetVertPadding
            );

            keyInputRect.width /= 2;
            keyInputRect.width -= (_horizontalLineSpacing / 2f);
            keyInputRect.width -= _buttonWidgetHorzPadding;
            keyInputRect.x += _buttonWidgetHorzPadding;

            valInputRect.width /= 2;
            valInputRect.width -= (_horizontalLineSpacing / 2f);
            valInputRect.width -= _buttonWidgetHorzPadding;
            valInputRect.x +=
                keyInputRect.width + _horizontalLineSpacing + _buttonWidgetHorzPadding;

            buttonRect.width -= _buttonWidgetHorzPadding + _buttonWidgetHorzPadding;
            buttonRect.x += _buttonWidgetHorzPadding;

            Rect bg = new Rect(position);
            bg.y = keyInputRect.y - (_buttonWidgetVertPadding / 2);
            bg.x = keyInputRect.x - (_buttonWidgetHorzPadding / 2);
            bg.width = buttonRect.width + (_buttonWidgetHorzPadding);
            bg.height =
                EditorGUIUtility.standardVerticalSpacing
                + (EditorGUIUtility.singleLineHeight * 2)
                + (_buttonWidgetVertPadding);
            EditorGUI.DrawRect(bg, new Color(0.1f, 0.1f, 0.1f));

            _keyVal = DrawProperty(keyInputRect, keyType, _keyVal);
            _valVal = DrawProperty(valInputRect, valType, _valVal);

            if (GUI.Button(buttonRect, "Add New"))
            {
                System.Type genericKVP = typeof(KVP<,>).MakeGenericType(keyType, valType);
                object boxedVal = Activator.CreateInstance(genericKVP, _keyVal, _valVal);

                int arraySize = kvps.arraySize;
                kvps.InsertArrayElementAtIndex(arraySize);
                kvps.GetArrayElementAtIndex(arraySize).boxedValue = boxedVal;
            }

            DrawRect(buttonRect, Color.yellow);
        }

        private object DrawProperty(Rect pos, Type type, object val)
        {
            switch (type)
            {
                case Type _ when type.IsSubclassOf(typeof(UnityEngine.Object)):
                    return EditorGUI.ObjectField(pos, (UnityEngine.Object)val, type, false);

                case Type _ when type == typeof(int):
                    return EditorGUI.IntField(pos, (int)val);

                case Type _ when type == typeof(string):
                    return EditorGUI.TextField(pos, (string)val);

                default:
                    return null;
            }

            // if (type is typeof(string)) {
            //
            // }
            // switch (type)
            // {
            //     case type == typeof(string):
            //         return EditorGUI.TextField(pos, (string)v);
            //     case int v:
            //     default:
            //         return null;
            // }
        }

        private void HorizontalLine(Rect position, Color color, GUIStyle style)
        {
            var c = GUI.color;
            GUI.color = color;
            GUI.Box(position, GUIContent.none, style);
            GUI.color = c;
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            float labelHeight =
                EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
            if (!_foldedOut)
            {
                return labelHeight - EditorGUIUtility.standardVerticalSpacing;
            }

            return labelHeight + GetDictionaryHeight(property) + GetAddKeyWidgetHeight();
        }

        private void DrawRect(Rect rect, Color color)
        {
            if (_rectsDebug)
            {
                EditorGUI.DrawRect(rect, color);
            }
        }
    }
}
