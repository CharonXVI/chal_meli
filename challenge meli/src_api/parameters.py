from pathlib import Path
import yaml


class parameters:
  
  @staticmethod
  def get_parameters():
      """
      Llama a los parametros impuestos en un yaml.
      """
      return Path(__file__).cwd().__str__() + '/config/parametros.yaml'
      
  
  @staticmethod
  def read_parameters():
      """Abre el archivo de parametros y retorna un formato yaml
      """
      ruta=Path(parameters.get_parameters())
      try:
        if isinstance(ruta,(str,Path)):
           with ruta.open('r') as f:
              return yaml.safe_load(f)
      except (FileNotFoundError,yaml.YAMLError,Exception) as e:
         raise
    
  @staticmethod
  def transformar_parametros():
      """Transforma los parametros a formato de uso
      """
      data=parameters.read_parameters()
      if data is None:
        raise ValueError("Fallo la lectura de los parametros")
      else:
        return  data['url'], data['parameters'], data['headers']



# session = Session()
# session.headers.update(headers)


