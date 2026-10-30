#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

class Controller : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // Input Properties
    Q_PROPERTY(double t1X READ t1X WRITE setT1X NOTIFY t1XChanged)
    Q_PROPERTY(double t1Z READ t1Z WRITE setT1Z NOTIFY t1ZChanged)
    Q_PROPERTY(double t1Yaw READ t1Yaw WRITE setT1Yaw NOTIFY t1YawChanged)

    Q_PROPERTY(double t2X READ t2X WRITE setT2X NOTIFY t2XChanged)
    Q_PROPERTY(double t2Z READ t2Z WRITE setT2Z NOTIFY t2ZChanged)
    Q_PROPERTY(double t2Yaw READ t2Yaw WRITE setT2Yaw NOTIFY t2YawChanged)

    Q_PROPERTY(QString f3CommandA READ f3CommandA WRITE setF3CommandA NOTIFY f3CommandAChanged)
    Q_PROPERTY(QString f3CommandB READ f3CommandB WRITE setF3CommandB NOTIFY f3CommandBChanged)

    // Output Overworld
    Q_PROPERTY(int overworldBlockX READ overworldBlockX NOTIFY resultsChanged)
    Q_PROPERTY(int overworldBlockZ READ overworldBlockZ NOTIFY resultsChanged)
    Q_PROPERTY(int overworldChunkX READ overworldChunkX NOTIFY resultsChanged)
    Q_PROPERTY(int overworldChunkZ READ overworldChunkZ NOTIFY resultsChanged)
    Q_PROPERTY(int overworldInChunkX READ overworldInChunkX NOTIFY resultsChanged)
    Q_PROPERTY(int overworldInChunkZ READ overworldInChunkZ NOTIFY resultsChanged)

    // Output Nether
    Q_PROPERTY(int netherBlockX READ netherBlockX NOTIFY resultsChanged)
    Q_PROPERTY(int netherBlockZ READ netherBlockZ NOTIFY resultsChanged)
    Q_PROPERTY(int netherChunkX READ netherChunkX NOTIFY resultsChanged)
    Q_PROPERTY(int netherChunkZ READ netherChunkZ NOTIFY resultsChanged)
    Q_PROPERTY(int netherInChunkX READ netherInChunkX NOTIFY resultsChanged)
    Q_PROPERTY(int netherInChunkZ READ netherInChunkZ NOTIFY resultsChanged)

    // Status & Distance
    Q_PROPERTY(double distanceBlocks READ distanceBlocks NOTIFY resultsChanged)
    Q_PROPERTY(int netherSavedBlocks READ netherSavedBlocks NOTIFY resultsChanged)
    Q_PROPERTY(bool isCalculated READ isCalculated NOTIFY resultsChanged)
    Q_PROPERTY(QString calcError READ calcError NOTIFY resultsChanged)

public:
    explicit Controller(QObject *parent = nullptr);

    // Getters for Inputs
    double t1X() const { return m_t1X; }
    double t1Z() const { return m_t1Z; }
    double t1Yaw() const { return m_t1Yaw; }

    double t2X() const { return m_t2X; }
    double t2Z() const { return m_t2Z; }
    double t2Yaw() const { return m_t2Yaw; }

    QString f3CommandA() const { return m_f3CommandA; }
    QString f3CommandB() const { return m_f3CommandB; }

    // Setters for Inputs
    void setT1X(double v);
    void setT1Z(double v);
    void setT1Yaw(double v);

    void setT2X(double v);
    void setT2Z(double v);
    void setT2Yaw(double v);

    void setF3CommandA(const QString &cmd);
    void setF3CommandB(const QString &cmd);

    // Getters for Outputs
    int overworldBlockX() const { return m_overworldBlockX; }
    int overworldBlockZ() const { return m_overworldBlockZ; }
    int overworldChunkX() const { return m_overworldChunkX; }
    int overworldChunkZ() const { return m_overworldChunkZ; }
    int overworldInChunkX() const { return m_overworldInChunkX; }
    int overworldInChunkZ() const { return m_overworldInChunkZ; }

    int netherBlockX() const { return m_netherBlockX; }
    int netherBlockZ() const { return m_netherBlockZ; }
    int netherChunkX() const { return m_netherChunkX; }
    int netherChunkZ() const { return m_netherChunkZ; }
    int netherInChunkX() const { return m_netherInChunkX; }
    int netherInChunkZ() const { return m_netherInChunkZ; }

    double distanceBlocks() const { return m_distanceBlocks; }
    int netherSavedBlocks() const { return m_netherSavedBlocks; }
    bool isCalculated() const { return m_isCalculated; }
    QString calcError() const { return m_calcError; }

    // Invokable Business Logic for QML
    Q_INVOKABLE void calculateStronghold();
    Q_INVOKABLE bool parseF3Command(const QString &text, int targetIndex);
    Q_INVOKABLE void reset();

signals:
    void t1XChanged();
    void t1ZChanged();
    void t1YawChanged();

    void t2XChanged();
    void t2ZChanged();
    void t2YawChanged();

    void f3CommandAChanged();
    void f3CommandBChanged();

    void resultsChanged();

private:
    double m_t1X = 0.0;
    double m_t1Z = 0.0;
    double m_t1Yaw = 0.0;

    double m_t2X = 0.0;
    double m_t2Z = 0.0;
    double m_t2Yaw = 0.0;

    QString m_f3CommandA;
    QString m_f3CommandB;

    int m_overworldBlockX = 0;
    int m_overworldBlockZ = 0;
    int m_overworldChunkX = 0;
    int m_overworldChunkZ = 0;
    int m_overworldInChunkX = 0;
    int m_overworldInChunkZ = 0;

    int m_netherBlockX = 0;
    int m_netherBlockZ = 0;
    int m_netherChunkX = 0;
    int m_netherChunkZ = 0;
    int m_netherInChunkX = 0;
    int m_netherInChunkZ = 0;

    double m_distanceBlocks = 0.0;
    int m_netherSavedBlocks = 0;
    bool m_isCalculated = false;
    QString m_calcError;
};

#endif // CONTROLLER_H
