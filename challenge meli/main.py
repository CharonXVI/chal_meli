from src_api.parameters import parameters as p
from src_api.manipulador import manipular_respuesta as mr
from src_api.conector import conector_api as c


def run_pipeline():
    """Pipeline para tomar los datos y dejarlos en un json
    """
    url,parametros,headers=p.transformar_parametros()
    response=c.obtener_datos(url,headers,parametros)

    datos=mr.transformar_a_json(response)

    df=mr.flatten_json(datos)
    print(df)

if __name__ == "__main__":
    run_pipeline()