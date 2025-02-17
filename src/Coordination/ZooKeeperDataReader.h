#pragma once
#include <string>
#include <memory>

namespace Poco
{
class Logger;
}

using LoggerPtr = std::shared_ptr<Poco::Logger>;

namespace DB
{

template<typename Storage>
void deserializeKeeperStorageFromSnapshot(Storage & storage, const std::string & snapshot_path, LoggerPtr log);

template<typename Storage>
void deserializeKeeperStorageFromSnapshotsDir(Storage & storage, const std::string & path, LoggerPtr log);

template<typename Storage>
void deserializeLogAndApplyToStorage(Storage & storage, const std::string & log_path, LoggerPtr log);

template<typename Storage>
void deserializeLogsAndApplyToStorage(Storage & storage, const std::string & path, LoggerPtr log);

}
