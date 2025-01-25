from sqlfluff.core.rules.base import BaseRule, LintFix, LintResult
from sqlfluff.core.rules.doc_decorators import document_fix_compatible, document_groups
from sqlfluff.core.rules.crawlers import SegmentCrawler
from sqlfluff.core.rules.config_info import RuleConfigInfo

@document_groups
@document_fix_compatible
class Rule_CAM01(BaseRule):
    """Ensure attribute names are in camelCase."""

    groups = ("all",)
    config_info = RuleConfigInfo(
        config_keywords=["camel_case"],
        config_defaults={"camel_case": True},
    )

    def _eval(self, segment, **kwargs):
        if segment.type == "identifier":
            identifier_name = segment.raw
            camel_case_name = ''.join(word.capitalize() if i != 0 else word for i, word in enumerate(identifier_name.split('_')))
            if identifier_name != camel_case_name:
                return LintResult(
                    anchor=segment,
                    fixes=[
                        LintFix.replace(
                            segment,
                            [segment.edit(camel_case_name)]
                        )
                    ]
                )
        return None