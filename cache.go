// Copyright 2013 The imageproxy authors.
// SPDX-License-Identifier: Apache-2.0

package imageproxy

// Cache 接口定义了存储任意数据的缓存相关的结构，接口的结构和 httpcache.Cache 类似
type Cache interface {
	// Get retrieves the cached data for the provided key.
	Get(key string) (data []byte, ok bool)

	// Set caches the provided data.
	Set(key string, data []byte)

	// Delete deletes the cached data at the specified key.
	Delete(key string)
}

// NopCache 是 Cache 的空对象模式
var NopCache = new(nopCache)

type nopCache struct{}

func (c nopCache) Get(string) ([]byte, bool) { return nil, false }
func (c nopCache) Set(string, []byte)        {}
func (c nopCache) Delete(string)             {}
