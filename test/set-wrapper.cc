// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "set-wrapper.h"

bool Set::test(const std::string& key) const noexcept {
	return m_core.find(key) != m_core.end();
}

void Set::set(const std::string& key) noexcept {
	m_core.insert(key);
}