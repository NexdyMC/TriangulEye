#include "controller.h"
#include <cmath>
#include <QRegularExpression>
#include <QStringList>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

Controller::Controller(QObject *parent)
    : QObject(parent)
{
    calculateStronghold();
}

void Controller::setT1X(double v)
{
    if (!qFuzzyCompare(m_t1X, v)) {
        m_t1X = v;
        emit t1XChanged();
        calculateStronghold();
    }
}

void Controller::setT1Z(double v)
{
    if (!qFuzzyCompare(m_t1Z, v)) {
        m_t1Z = v;
        emit t1ZChanged();
        calculateStronghold();
    }
}

void Controller::setT1Yaw(double v)
{
    if (!qFuzzyCompare(m_t1Yaw, v)) {
        m_t1Yaw = v;
        emit t1YawChanged();
        calculateStronghold();
    }
}

void Controller::setT2X(double v)
{
    if (!qFuzzyCompare(m_t2X, v)) {
        m_t2X = v;
        emit t2XChanged();
        calculateStronghold();
    }
}

void Controller::setT2Z(double v)
{
    if (!qFuzzyCompare(m_t2Z, v)) {
        m_t2Z = v;
        emit t2ZChanged();
        calculateStronghold();
    }
}

void Controller::setT2Yaw(double v)
{
    if (!qFuzzyCompare(m_t2Yaw, v)) {
        m_t2Yaw = v;
        emit t2YawChanged();
        calculateStronghold();
    }
}

void Controller::setF3CommandA(const QString &cmd)
{
    if (m_f3CommandA != cmd) {
        m_f3CommandA = cmd;
        emit f3CommandAChanged();
        parseF3Command(cmd, 1);
    }
}

void Controller::setF3CommandB(const QString &cmd)
{
    if (m_f3CommandB != cmd) {
        m_f3CommandB = cmd;
        emit f3CommandBChanged();
        parseF3Command(cmd, 2);
    }
}

void Controller::calculateStronghold()
{
    m_calcError.clear();

    if (m_t1X == 0.0 && m_t1Z == 0.0 && m_t1Yaw == 0.0 &&
        m_t2X == 0.0 && m_t2Z == 0.0 && m_t2Yaw == 0.0) {
        m_isCalculated = false;
        m_overworldBlockX = 0;
        m_overworldBlockZ = 0;
        m_overworldChunkX = 0;
        m_overworldChunkZ = 0;
        m_overworldInChunkX = 0;
        m_overworldInChunkZ = 0;
        m_netherBlockX = 0;
        m_netherBlockZ = 0;
        m_netherChunkX = 0;
        m_netherChunkZ = 0;
        m_netherInChunkX = 0;
        m_netherInChunkZ = 0;
        m_distanceBlocks = 0.0;
        m_netherSavedBlocks = 0;
        emit resultsChanged();
        return;
    }

    if (qFuzzyCompare(m_t1X, m_t2X) && qFuzzyCompare(m_t1Z, m_t2Z) && qFuzzyCompare(m_t1Yaw, m_t2Yaw)) {
        m_isCalculated = false;
        m_calcError = QStringLiteral("⚠️ Masukkan 2 posisi lemparan yang berbeda.");
        emit resultsChanged();
        return;
    }

    const double rad1 = (m_t1Yaw * M_PI) / 180.0;
    const double dx1 = -std::sin(rad1);
    const double dz1 = std::cos(rad1);

    const double rad2 = (m_t2Yaw * M_PI) / 180.0;
    const double dx2 = -std::sin(rad2);
    const double dz2 = std::cos(rad2);

    const double det = (dx1 * dz2) - (dz1 * dx2);

    if (std::abs(det) < 0.0001) {
        m_calcError = QStringLiteral("⚠️ Garis lemparan sejajar (paralel)! Geser posisi lemparan kedua.");
        m_isCalculated = false;
        emit resultsChanged();
        return;
    }

    const double deltaX = m_t2X - m_t1X;
    const double deltaZ = m_t2Z - m_t1Z;
    const double t1 = ((deltaX * dz2) - (deltaZ * dx2)) / det;

    const double rawX = m_t1X + (t1 * dx1);
    const double rawZ = m_t1Z + (t1 * dz1);

    m_overworldBlockX = static_cast<int>(std::round(rawX));
    m_overworldBlockZ = static_cast<int>(std::round(rawZ));

    m_overworldChunkX = static_cast<int>(std::floor(m_overworldBlockX / 16.0));
    m_overworldChunkZ = static_cast<int>(std::floor(m_overworldBlockZ / 16.0));

    m_overworldInChunkX = ((m_overworldBlockX % 16) + 16) % 16;
    m_overworldInChunkZ = ((m_overworldBlockZ % 16) + 16) % 16;

    m_netherBlockX = static_cast<int>(std::floor(m_overworldBlockX / 8.0));
    m_netherBlockZ = static_cast<int>(std::floor(m_overworldBlockZ / 8.0));

    m_netherChunkX = static_cast<int>(std::floor(m_netherBlockX / 16.0));
    m_netherChunkZ = static_cast<int>(std::floor(m_netherBlockZ / 16.0));

    m_netherInChunkX = ((m_netherBlockX % 16) + 16) % 16;
    m_netherInChunkZ = ((m_netherBlockZ % 16) + 16) % 16;

    m_distanceBlocks = std::sqrt(std::pow(m_overworldBlockX - m_t1X, 2) + std::pow(m_overworldBlockZ - m_t1Z, 2));
    m_netherSavedBlocks = static_cast<int>(std::round(m_distanceBlocks - (m_distanceBlocks / 8.0)));

    m_isCalculated = true;
    emit resultsChanged();
}

bool Controller::parseF3Command(const QString &text, int targetIndex)
{
    const QString trimmed = text.trimmed();
    if (trimmed.isEmpty()) {
        return false;
    }

    const QStringList tokens = trimmed.split(QRegularExpression(QStringLiteral("\\s+")), Qt::SkipEmptyParts);
    bool found = false;
    double xVal = 0.0;
    double zVal = 0.0;
    double yawVal = 0.0;

    for (int i = 0; i < tokens.size(); ++i) {
        if (tokens[i] == QStringLiteral("@s") || tokens[i] == QStringLiteral("@p")) {
            if (i + 4 < tokens.size()) {
                bool okX = false, okZ = false, okYaw = false;
                xVal = tokens[i + 1].toDouble(&okX);
                // tokens[i + 2] is Y coord
                zVal = tokens[i + 3].toDouble(&okZ);
                yawVal = tokens[i + 4].toDouble(&okYaw);

                if (okX && okZ && okYaw) {
                    found = true;
                    break;
                }
            }
        }
    }

    // Fallback: If user enters just numbers e.g. "X Z Yaw" or "X Y Z Yaw Pitch"
    if (!found) {
        if (tokens.size() == 3) {
            bool okX = false, okZ = false, okYaw = false;
            xVal = tokens[0].toDouble(&okX);
            zVal = tokens[1].toDouble(&okZ);
            yawVal = tokens[2].toDouble(&okYaw);
            if (okX && okZ && okYaw) found = true;
        } else if (tokens.size() >= 5) {
            bool okX = false, okZ = false, okYaw = false;
            xVal = tokens[0].toDouble(&okX);
            zVal = tokens[2].toDouble(&okZ);
            yawVal = tokens[3].toDouble(&okYaw);
            if (okX && okZ && okYaw) found = true;
        }
    }

    if (found) {
        if (targetIndex == 1) {
            m_t1X = xVal;
            m_t1Z = zVal;
            m_t1Yaw = yawVal;
            emit t1XChanged();
            emit t1ZChanged();
            emit t1YawChanged();
        } else {
            m_t2X = xVal;
            m_t2Z = zVal;
            m_t2Yaw = yawVal;
            emit t2XChanged();
            emit t2ZChanged();
            emit t2YawChanged();
        }
        calculateStronghold();
        return true;
    }

    return false;
}

void Controller::reset()
{
    m_t1X = 0.0;
    m_t1Z = 0.0;
    m_t1Yaw = 0.0;

    m_t2X = 0.0;
    m_t2Z = 0.0;
    m_t2Yaw = 0.0;

    m_f3CommandA.clear();
    m_f3CommandB.clear();

    emit t1XChanged();
    emit t1ZChanged();
    emit t1YawChanged();

    emit t2XChanged();
    emit t2ZChanged();
    emit t2YawChanged();

    emit f3CommandAChanged();
    emit f3CommandBChanged();

    calculateStronghold();
}
