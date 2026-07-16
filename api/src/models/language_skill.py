import enum


class LanguageSkill(str, enum.Enum):
    writtenComprehension = "writtenComprehension"
    oralComprehension = "oralComprehension"
    writtenExpression = "writtenExpression"
    oralExpression = "oralExpression"
    phonetics = "phonetics"
