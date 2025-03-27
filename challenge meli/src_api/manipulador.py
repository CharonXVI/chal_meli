import json
import pandas as pd

class manipular_respuesta:

    @staticmethod
    def transformar_a_json(response):
        """transforma la respuesta a un json file
        """
        try:
          return json.loads(response.text)

        except Exception as e:
           raise
    
    @staticmethod
    def flatten_json(datos):
      """Recibe el json y arma un dataframe
      """

      try:
         if datos is None:
            return None
         else:
            df=pd.DataFrame(datos['data'])

            quote=pd.json_normalize(df['quote'])

            return pd.concat([df,quote],axis=1).drop("quote",axis=1)
      except Exception as e:
         raise
