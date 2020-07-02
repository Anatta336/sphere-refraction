//UNITY_SHADER_NO_UPGRADE
#ifndef SCHLICK_INCLUDED
#define SCHLICK_INCLUDED

// approximation of the Fresnel equation for reflectance
// based on https://graphics.stanford.edu/courses/cs148-10-summer/docs/2006--degreve--reflection_refraction.pdf
void Schlick_float(
    float n1, float n2,
    float3 normal, float3 rayDirection,
    out float reflectance)
{
    float r0 = (n1 - n2) / (n1 + n2);
    r0 *= r0;

    float cosX = abs(dot(normal, rayDirection));

    if (abs(cosX) < 0.0001)
    {
        reflectance = 1.0;
        return;
    }

    if (n1 > n2)
    {
        float n = n1 / n2;
        float sinT2 = n * n * (1.0 - cosX * cosX);

        // detect total internal reflection
        if (sinT2 > 1.0)
        {
            reflectance = 1.0;
            return;
        }

        cosX = sqrt(1.0 - sinT2);
    }

    float x = 1.0 - cosX;

    // chained multiply is (probably) faster than pow(x, 5)
    reflectance = r0 + (1.0 - r0) * x*x*x*x*x;
}
#endif //SCHLICK_INCLUDED
