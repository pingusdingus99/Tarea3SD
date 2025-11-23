import pandas as pd
import matplotlib.pyplot as plt
from wordcloud import WordCloud

# CONFIGURACIÓN
ARCHIVO_ENTRADA = '../dump/resultados_llm.txt'
ARCHIVO_SALIDA_BARRAS = '../dump/grafico_barras_llm.png'
ARCHIVO_SALIDA_NUBE = '../dump/nube_palabras_llm.png'
TITULO_GRAFICO = 'Top 50 Palabras más Frecuentes (LLM)'
TOP_N = 50

def generar_visualizaciones():
    try:
        # 1. Cargar datos
        print(f"Leyendo datos de {ARCHIVO_ENTRADA}...")
        df = pd.read_csv(ARCHIVO_ENTRADA, header=None, names=['palabra', 'frecuencia'])
        
        # 2. Limpieza
        df['frecuencia'] = pd.to_numeric(df['frecuencia'], errors='coerce')
        df = df.dropna()
        
        # PARTE A: GRÁFICO DE BARRAS
        print("Generando gráfico de barras...")
        
        # Ordenamos para el top y luego invertimos para el gráfico horizontal
        df_sorted = df.sort_values(by='frecuencia', ascending=False).head(TOP_N)
        df_plot = df_sorted.sort_values(by='frecuencia', ascending=True)

        plt.figure(figsize=(10, 8))
        plt.barh(df_plot['palabra'], df_plot['frecuencia'], color='skyblue', edgecolor='black')
        plt.xlabel('Frecuencia')
        plt.ylabel('Palabras')
        plt.title(TITULO_GRAFICO, fontsize=16, fontweight='bold')
        plt.grid(axis='x', linestyle='--', alpha=0.7)
        plt.tight_layout()
        plt.savefig(ARCHIVO_SALIDA_BARRAS, dpi=300)
        plt.close() # Cerramos la figura para liberar memoria
        print(f"Barras guardadas en: {ARCHIVO_SALIDA_BARRAS}")

        # --- PARTE B: NUBE DE PALABRAS (Nueva funcionalidad) ---
        print("Generando nube de palabras...")

        # WordCloud necesita un diccionario {palabra: frecuencia}
        # Convertimos todo el dataframe (no solo el top 50) para que la nube sea más rica
        frecuencias = dict(zip(df['palabra'], df['frecuencia']))

        # Configuramos la nube
        wc = WordCloud(
            width=800, 
            height=400, 
            background_color='white', 
            colormap='viridis', # Puedes cambiar a 'plasma', 'inferno', 'blue', etc.
            max_words=200       # Máximo de palabras a mostrar en la nube
        )
        
        # Generamos la nube usando las frecuencias pre-calculadas
        wc.generate_from_frequencies(frecuencias)

        # Guardamos la imagen directamente
        wc.to_file(ARCHIVO_SALIDA_NUBE)
        print(f"Nube guardada en: {ARCHIVO_SALIDA_NUBE}")

    except FileNotFoundError:
        print(f"Error: No se encontró el archivo '{ARCHIVO_ENTRADA}'.")
    except ImportError:
        print("Error: Falta la librería 'wordcloud'. Instálala con: pip install wordcloud")
    except Exception as e:
        print(f"Ocurrió un error inesperado: {e}")

if __name__ == "__main__":
    generar_visualizaciones()