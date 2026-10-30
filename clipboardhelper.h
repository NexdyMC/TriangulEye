#pragma once
#include <QObject>
#include <QGuiApplication>
#include <QClipboard>

class ClipboardHelper : public QObject {
    Q_OBJECT
public:
    explicit ClipboardHelper(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void copyText(const QString &text) {
        QClipboard *clipboard = QGuiApplication::clipboard();
        if (clipboard) {
            clipboard->setText(text);
        }
    }

    Q_INVOKABLE QString getText() const {
        QClipboard *clipboard = QGuiApplication::clipboard();
        if (clipboard) {
            return clipboard->text();
        }
        return QString();
    }
};
