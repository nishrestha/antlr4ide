package com.github.jknack.antlr4ide.ui.labeling

import com.google.inject.Inject
import com.github.jknack.antlr4ide.lang.Options
import com.github.jknack.antlr4ide.lang.Option
import com.github.jknack.antlr4ide.lang.Tokens
import com.github.jknack.antlr4ide.lang.V3Token
import com.github.jknack.antlr4ide.lang.V4Token
import com.github.jknack.antlr4ide.lang.Import
import com.github.jknack.antlr4ide.lang.Imports
import com.github.jknack.antlr4ide.lang.ParserRule
import com.github.jknack.antlr4ide.lang.RuleAction
import com.github.jknack.antlr4ide.lang.LexerRule
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.util.FeatureMap
import com.github.jknack.antlr4ide.lang.RuleBlock
import com.github.jknack.antlr4ide.lang.LexerRuleBlock
import com.github.jknack.antlr4ide.lang.ExceptionGroup
import com.github.jknack.antlr4ide.lang.TokenVocab
import com.github.jknack.antlr4ide.lang.LocalVars
import com.github.jknack.antlr4ide.lang.Mode
import com.github.jknack.antlr4ide.lang.GrammarAction

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class Antlr4LabelProvider extends org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider {

  @Inject
  new(org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider delegate) {
    super(delegate);
  }

  def text(EObject object) {
    var label = labelFeature(object.eClass, "name")
    if(label == null) {
      label = labelFeature(object.eClass, "id")
    }
    if (label != null) {
      object.eGet(label)
    } else {
      object.eClass.name.toLowerCase
    }
  }

  def text(Import delegate) {
    delegate.importURI.name
  }

  def text(Options options) {
    "options"
  }

  def text(TokenVocab tokenVocab) {
    tokenVocab.importURI.name
  }

  def text(Tokens tokens) {
    "tokens"
  }

  def text(LocalVars locals) {
    "locals " + locals.body
  }

  def text(GrammarAction action) {
    if (action.scope == null) {
      action.name
    } else {
      action.scope + "::" + action.name
    }
  }

  def text(ParserRule rule) {
    var text = rule.name
    if (rule.args != null) {
      text = text + " " + rule.args
    }
    if (rule.^return != null) {
      text = text + " : "
      val values = rule.^return.body
          .replace("[", "")
          .replace("]", "")
          .trim()
          .split("\\s+");

      if (values.length > 2) {
        text = text + "..."
      } else {
        text = text + values.get(0)
      }
    }
    text
  }

  def text(RuleBlock empty) {
    null
  }

  def text(LexerRuleBlock empty) {
    null
  }

  def text(com.github.jknack.antlr4ide.lang.Exceptions empty) {
    null
  }

  def text(ExceptionGroup empty) {
    null
  }

  def image(Mode mode) {
    return "mode.png"
  }

  def image(ParserRule rule) {
    return "rule.png"
  }

  def image(Options options) {
    return "options.png"
  }

  def image(Option option) {
    return "option.png"
  }

  def image(Tokens tokens) {
    return "token.png"
  }

  def image(V3Token tokens) {
    return "token.png"
  }

  def image(V4Token tokens) {
    return "token.png"
  }

  def image(LexerRule rule) {
    if (rule.fragment) {
      return "fragment.png"
    } else {
      return "token.png"
    }
  }

  def image(GrammarAction action) {
    return "action.png"
  }

  def image(RuleAction action) {
    return "action.png"
  }

  def image(Imports imports) {
    return "imports.png"
  }

  def image(Import delegate) {
    return "import.png"
  }

  def image(TokenVocab tokenVocab) {
    return "import.png"
  }

  def image(LocalVars locals) {
    return "locals.png"
  }

  protected def EStructuralFeature labelFeature(EClass eClass, String feature) {
    var EAttribute result = null
    for (eAttribute : eClass.EAllAttributes) {
      if (!eAttribute.many && eAttribute.EType.instanceClass != FeatureMap.Entry) {
        if (feature.equalsIgnoreCase(eAttribute.getName())) {
          return eAttribute;
        } else if (result == null) {
          result = eAttribute;
        } else if (eAttribute.EAttributeType.instanceClass == String
            && result.EAttributeType.instanceClass != String) {
          result = eAttribute;
        }
      }
    }
    return result;
  }
}
