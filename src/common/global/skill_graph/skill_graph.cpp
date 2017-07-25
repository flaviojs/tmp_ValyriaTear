////////////////////////////////////////////////////////////////////////////////
//            Copyright (C) 2017 by Bertram (Valyria Tear)
//                         All Rights Reserved
//
// This code is licensed under the GNU GPL version 2. It is free software
// and you may modify it and/or redistribute it under the terms of this license.
// See http://www.gnu.org/copyleft/gpl.html for details.
////////////////////////////////////////////////////////////////////////////////

#include "skill_graph.h"

namespace vt_global {

bool SkillGraph::Initialize(const std::string& skill_graph_file)
{
    vt_script::ReadScriptDescriptor script;
    if (!script.OpenFile(skill_graph_file)) {
        PRINT_WARNING << "Couldn't open file: " << skill_graph_file << std::endl;
        return false;
    }

    // Load skill tree data
    std::vector<uint32_t> nodes_ids;
    script.ReadTableKeys("skill_graph", nodes_ids);
    if (nodes_ids.empty()) {
        PRINT_WARNING << "Empty 'skill_graph' table in " << skill_graph_file << std::endl;
        return false;
    }

    if (!script.OpenTable("skill_graph")) {
        PRINT_WARNING << "Couldn't open table 'skill_graph' in " << skill_graph_file << std::endl;
        return false;
    }

    // Read each node data
    for (uint32_t node_id : nodes_ids) {
        if (!script.OpenTable(node_id)) {
            PRINT_WARNING << "Couldn't open table '" << node_id
                          << "' in " << skill_graph_file << std::endl;
            return false;
        }

        // Read base data
        uint32_t x_location = script.ReadUInt("x_location");
        uint32_t y_location = script.ReadUInt("y_location");
        std::string icon_file = script.ReadString("icon_file");
        uint32_t experience_points_needed = script.ReadUInt("experience_points_needed");
        uint32_t skill_id_learned = script.ReadUInt("skill_id_learned");

        SkillNode* skill_node = new SkillNode(node_id,
                                              x_location,
                                              y_location,
                                              icon_file,
                                              experience_points_needed,
                                              skill_id_learned);

        // Read potential other data
        _ReadItemsNeeded(script, skill_node);
        _ReadStatsUpgrades(script, skill_node);
        _ReadNodeLinks(script, skill_node);

        // Add the node to the graph
        _skill_graph_data.emplace_back(skill_node);

        script.CloseTable(); // node_id
    }
    return true;
}

void SkillGraph::_ReadItemsNeeded(vt_script::ReadScriptDescriptor& script,
                                 SkillNode* skill_node)
{
    std::vector<uint32_t> item_ids;
    script.ReadTableKeys("items_needed", item_ids);

    // No needed items can happen
    if (item_ids.empty() || !script.OpenTable("items_needed"))
        return;

    for (uint32_t item_id : item_ids) {
        uint32_t item_number = script.ReadUInt(item_id);
        skill_node->AddNeededItem(item_id, item_number);
    }

    script.CloseTable(); // items_needed
}

void SkillGraph::_ReadStatsUpgrades(vt_script::ReadScriptDescriptor& script,
                                   SkillNode* skill_node)
{
    std::vector<uint32_t> stat_ids;
    script.ReadTableKeys("stats", stat_ids);

    // No stats upgrades can happen
    if (stat_ids.empty() || !script.OpenTable("stats"))
        return;

    for (uint32_t stat_id: stat_ids) {
        uint32_t upgrade = script.ReadUInt(stat_id);
        skill_node->AddStatUpgrade(stat_id, upgrade);
    }

    script.CloseTable(); // stat
}

void SkillGraph::_ReadNodeLinks(vt_script::ReadScriptDescriptor& script,
                               SkillNode* skill_node)
{
    std::vector<uint32_t> node_ids;
    script.ReadUIntVector("links", node_ids);

    // No node ids can happen for end of tree.
    if (node_ids.empty() || !script.OpenTable("links"))
        return;

    for (uint32_t node_id: node_ids) {
        skill_node->AddNodeLink(node_id);
    }

    script.CloseTable(); // links
}

SkillNode* SkillGraph::GetSkillNode(uint32_t skill_node_id)
{
    for (SkillNode* skill_node : _skill_graph_data) {
        if (skill_node->GetId() == skill_node_id)
            return skill_node;
    }
    return nullptr;
}

} // namespace vt_global