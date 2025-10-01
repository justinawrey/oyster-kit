using Unity.Mathematics;
using UnityEngine;

namespace BlueOyster.Dynamics
{
    public class Dynamics
    {
        private float xp;
        private float y,
            yd;
        private float _w,
            _z,
            _d,
            k1,
            k2,
            k3;

        public Dynamics(DynamicsPresetSO preset, float x0)
        {
            init(preset.F, preset.Z, preset.R, x0);
        }

        public Dynamics(float f, float z, float r, float x0)
        {
            init(f, z, r, x0);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            initCoefficients(preset.F, preset.Z, preset.R);
        }

        private void init(float f, float z, float r, float x0)
        {
            initCoefficients(f, z, r);
            xp = x0;
            y = x0;
            yd = 0;
        }

        private void initCoefficients(float f, float z, float r)
        {
            _w = 2 * math.PI * f;
            _z = z;
            _d = _w * math.sqrt(math.abs(z * z - 1));
            k1 = z / (math.PI * f);
            k2 = 1 / (_w * _w);
            k3 = r * z / _w;
        }

        public float Update(float T, float x)
        {
            // hack but ok
            if (T == 0)
            {
                return xp;
            }

            var xd = (x - xp) / T;
            xp = x;

            float k1_stable,
                k2_stable;
            if (_w * T < _z)
            {
                k1_stable = k1;

                // ugly code to avoid an allocating
                // Mathf.Max() because this is a super hot path!
                float a = k2;
                float b = T * T / 2 + T * k1 / 2;
                float c = T * k1;

                float largest = a;
                if (b > largest)
                {
                    largest = b;
                }
                if (c > largest)
                {
                    largest = c;
                }

                k2_stable = largest;
            }
            else
            {
                float t1 = math.exp(-_z * _w * T);
                float alpha = 2 * t1 * (_z <= 1 ? math.cos(T * _d) : math.cosh(T * _d));
                float beta = t1 * t1;
                float t2 = T / (1 + beta - alpha);
                k1_stable = (1 - beta) * t2;
                k2_stable = T * t2;
            }

            y = y + T * yd;
            yd = yd + T * (x + k3 * xd - y - k1_stable * yd) / k2_stable;
            return y;
        }
    }

    public class Dynamics2
    {
        private Vector2 xp;
        private Vector2 y,
            yd;
        private float _w,
            _z,
            _d,
            k1,
            k2,
            k3;

        public Dynamics2(DynamicsPresetSO preset, Vector2 x0)
        {
            init(preset.F, preset.Z, preset.R, x0);
        }

        public Dynamics2(float f, float z, float r, Vector2 x0)
        {
            init(f, z, r, x0);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            initCoefficients(preset.F, preset.Z, preset.R);
        }

        private void init(float f, float z, float r, Vector2 x0)
        {
            initCoefficients(f, z, r);
            xp = x0;
            y = x0;
            yd = Vector2.zero;
        }

        private void initCoefficients(float f, float z, float r)
        {
            _w = 2 * math.PI * f;
            _z = z;
            _d = _w * math.sqrt(math.abs(z * z - 1));
            k1 = z / (math.PI * f);
            k2 = 1 / (_w * _w);
            k3 = r * z / _w;
        }

        public Vector2 Update(float T, Vector2 x)
        {
            // hack but ok
            if (T == 0)
            {
                return xp;
            }

            var xd = (x - xp) / T;
            xp = x;

            float k1_stable,
                k2_stable;
            if (_w * T < _z)
            {
                k1_stable = k1;

                // ugly code to avoid an allocating
                // Mathf.Max() because this is a super hot path!
                float a = k2;
                float b = T * T / 2 + T * k1 / 2;
                float c = T * k1;

                float largest = a;
                if (b > largest)
                {
                    largest = b;
                }
                if (c > largest)
                {
                    largest = c;
                }

                k2_stable = largest;
            }
            else
            {
                float t1 = math.exp(-_z * _w * T);
                float alpha = 2 * t1 * (_z <= 1 ? math.cos(T * _d) : math.cosh(T * _d));
                float beta = t1 * t1;
                float t2 = T / (1 + beta - alpha);
                k1_stable = (1 - beta) * t2;
                k2_stable = T * t2;
            }

            y = y + T * yd;
            yd = yd + T * (x + k3 * xd - y - k1_stable * yd) / k2_stable;
            return y;
        }
    }

    public class Dynamics3
    {
        private Vector3 xp;
        private Vector3 y,
            yd;
        private float _w,
            _z,
            _d,
            k1,
            k2,
            k3;

        public Dynamics3(DynamicsPresetSO preset, Vector3 x0)
        {
            init(preset.F, preset.Z, preset.R, x0);
        }

        public Dynamics3(float f, float z, float r, Vector3 x0)
        {
            init(f, z, r, x0);
        }

        public void ChangePreset(DynamicsPresetSO preset)
        {
            initCoefficients(preset.F, preset.Z, preset.R);
        }

        private void init(float f, float z, float r, Vector3 x0)
        {
            initCoefficients(f, z, r);
            xp = x0;
            y = x0;
            yd = Vector3.zero;
        }

        private void initCoefficients(float f, float z, float r)
        {
            _w = 2 * math.PI * f;
            _z = z;
            _d = _w * math.sqrt(math.abs(z * z - 1));
            k1 = z / (math.PI * f);
            k2 = 1 / (_w * _w);
            k3 = r * z / _w;
        }

        public Vector3 Update(float T, Vector3 x)
        {
            // hack but ok
            if (T == 0)
            {
                return xp;
            }

            Vector3 xd = (x - xp) / T;
            xp = x;

            float k1_stable,
                k2_stable;
            if (_w * T < _z)
            {
                k1_stable = k1;

                // ugly code to avoid an allocating
                // Mathf.Max() because this is a super hot path!
                float a = k2;
                float b = T * T / 2 + T * k1 / 2;
                float c = T * k1;

                float largest = a;
                if (b > largest)
                {
                    largest = b;
                }
                if (c > largest)
                {
                    largest = c;
                }

                k2_stable = largest;
            }
            else
            {
                float t1 = math.exp(-_z * _w * T);
                float alpha = 2 * t1 * (_z <= 1 ? math.cos(T * _d) : math.cosh(T * _d));
                float beta = t1 * t1;
                float t2 = T / (1 + beta - alpha);
                k1_stable = (1 - beta) * t2;
                k2_stable = T * t2;
            }

            y = y + T * yd;
            yd = yd + T * (x + k3 * xd - y - k1_stable * yd) / k2_stable;
            return y;
        }
    }
}
