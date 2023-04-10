// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once

#include <string>
#include "robin_hood.h"

class Set final {
public:
	explicit Set(size_t size) {
		m_core.reserve(size);
	}

	bool test(const std::string& key) const noexcept;
	void set(const std::string& key) noexcept;

private:
	robin_hood::unordered_flat_set<std::string> m_core;
};