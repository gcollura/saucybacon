#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);
    ~Utils();

    Q_INVOKABLE bool createDir(const QString& dirName);
    Q_INVOKABLE QString homePath() const;

    Q_INVOKABLE bool write(const QString& dirName, const QString& fileName, const QString& contents);
    Q_INVOKABLE QString read(const QString& dirName, const QString& fileName);

Q_SIGNALS:

protected:

};

#endif // MYTYPE_H
