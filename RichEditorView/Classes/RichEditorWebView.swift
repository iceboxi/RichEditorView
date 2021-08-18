//
//  RichEditorWebView.swift
//  RichEditorView
//
//  Created by C. Bess on 9/18/19.
//

import WebKit

public class RichEditorWebView: WKWebView {
    var replyEnabled = false
    var editingEnabled = true
    var account: AccountBaseModel?
    var quoteRefID: String?
    
    public var accessoryView: UIView?
    
    public override var inputAccessoryView: UIView? {
        return accessoryView
    }

    @objc func reply(_ sender: Any?) {
        let script = "window.getSelection().toString()"
        evaluateJavaScript(script) { [weak self] result, error in
            guard let self = self else { return }
            if let string = result as? String {
                let model = MessageReplyBarView.DirectReply(type: .string, message: string, account: self.account, quoteRefID: self.quoteRefID, reportItemID: self.quoteRefID)
                
                NotificationCenter.default.post(name: .directReply, object: nil, userInfo: ["reply": model])
            }
        }
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        } else if action == #selector(reply(_:)) && replyEnabled {
            return true
        } else if canShowWhenEditing(action) && editingEnabled {
            return super.canPerformAction(action, withSender: sender)
        } else {
            return false
        }
    }
    
    private func canShowWhenEditing(_ action: Selector) -> Bool {
        switch action {
        case #selector(paste(_:)):
            return true
        case #selector(select(_:)):
            return true
        case #selector(selectAll(_:)):
            return true
        case #selector(delete(_:)):
            return true
        case #selector(cut(_:)):
            return true
        default:
            return false
        }
    }
}
