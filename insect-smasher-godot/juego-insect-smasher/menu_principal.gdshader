shader_type canvas_item;

// Configuración
uniform float speed = 1.5;      // Velocidad suave
uniform float amplitude = 0.005; // Movimiento muy corto (para que no se rompa la imagen)
uniform float frequency = 10.0; // Ondas

void fragment() {
    // 1. Leemos el color original del píxel
    vec4 color_original = texture(TEXTURE, UV);

    // 2. MAGIA MATEMÁTICA: Detectamos cuánto de "Verde" tiene este píxel
    // Restamos al canal Verde (g) el máximo de Rojo (r) y Azul (b).
    // Si el resultado es alto, es una planta. Si es bajo, es tierra o cielo.
    float es_planta = color_original.g - max(color_original.r, color_original.b);

    // 3. Limpiamos el valor (solo nos interesa si es positivo) y lo exageramos un poco
    float mascara = clamp(es_planta * 4.0, 0.0, 1.0);

    // 4. Calculamos el movimiento, pero lo MULTIPLICAMOS por la máscara
    // Si la máscara es 0 (tierra), el movimiento será 0.
    vec2 new_uv = UV;
    new_uv.x += sin(UV.y * frequency + TIME * speed) * amplitude * mascara;

    // 5. Pintamos el píxel
    COLOR = texture(TEXTURE, new_uv);
}