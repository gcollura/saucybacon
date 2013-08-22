#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString helloWorld READ helloWorld WRITE setHelloWorld NOTIFY helloWorldChanged )

public:
    explicit Utils(QObject *parent = 0);
    ~Utils();

    Q_INVOKABLE bool createDir(const QString& dirName);

Q_SIGNALS:
    void helloWorldChanged();

protected:
    QString helloWorld() { return m_message; }
    void setHelloWorld(QString msg) { m_message = msg; Q_EMIT helloWorldChanged(); }

    QString m_message;
};

#endif // MYTYPE_H
