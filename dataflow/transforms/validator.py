from pydantic import ValidationError
from models import CryptoPrice
import apache_beam as beam

class EventValidator(beam.DoFn):
    VALID = "valid"
    INVALID = "invalid"

    def process(self,element):
        try:
            CryptoPrice.model_validate(element)
            yield beam.pvalue.TaggedOutput(
                self.VALID,
                element
            )

        except ValidationError as e:
            element["validation_error"] = str(e)
            yield beam.pvalue.TaggedOutput(
                self.INVALID,
                element
            )